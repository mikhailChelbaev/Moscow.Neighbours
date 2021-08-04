//
//  MapViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.07.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    enum State {
        case showLocationAtFirstTime
        case showCurrentLocation
        case `default`
    }
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        return map
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }()
    
    private lazy var manager: BottomSheetsManager = {
        let manager = BottomSheetsManager(presenter: self)
        manager.addController(routesController)
        manager.addController(routeDescriptionController, availableStates: [.middle, .top])
        manager.addController(personController, availableStates: [.middle, .top])
        return manager
    }()
    
    private let routesController: RouteViewController = .init()
    
    private let routeDescriptionController: RouteDescriptionViewController = .init()
    
    private let personController: PersonViewController = .init()
    
    private var state: State = .showLocationAtFirstTime
    
    private var currentlySelectedRoute: Route?
    
    private var currentlySelectedPerson: PersonInfo?
    
    private let routeOptimizer: RouteFinder = NearestCoordinatesFinder()
    
    private var currentLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        
        routesController.showRouteCompletion = showRoute(_:)
        
        view.addSubview(mapView)
        mapView.stickToSuperviewEdges(.all)
        
        addChild(routesController)
        view.addSubview(routesController.view)
        routesController.view.stickToSuperviewEdges(.all)
        
        [routeDescriptionController, personController].forEach { controller in
            addChild(controller)
            view.addSubview(controller.view)
            controller.view.stickToSuperviewEdges(.all)
            controller.drawerView.setState(.dismissed, animated: false)
        }
        
        manager.show(routesController, state: .middle, animated: false)
    }
    
    private func registerAnnotationViews() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(PlaceClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
}

// MARK: - extension MapViewController (Route)

extension MapViewController {
    
    private func showRoute(_ route: Route) {
        routeDescriptionController.updateRoute(route, closeAction: closeRouteDescription)
        manager.show(routeDescriptionController, state: .middle)
        mapView.addAnnotations(route.personsInfo)
        currentlySelectedRoute = route
        
        var coordinates: [CLLocationCoordinate2D] = route.personsInfo.compactMap({ $0.coordinate })
        
        guard coordinates.count > 0 else { return }
        
        var nearestCoordinate: CLLocationCoordinate2D?
        if let currentLocation = currentLocation {
            nearestCoordinate = routeOptimizer.findNearestCoordinate(from: currentLocation, coordinates: coordinates)
        } else {
            nearestCoordinate = coordinates.removeFirst()
        }
        
        guard let nearestCoordinate = nearestCoordinate else { return }
        
        routeOptimizer.findRoute(from: nearestCoordinate, coordinates: coordinates) { [weak self] route in
            for points in route {
                self?.drawRoute(p1: points.p1, p2: points.p2)
            }
        }
    }
    
    private func closeRouteDescription() {
        currentlySelectedRoute = nil
        manager.closeCurrent()
        
        // remove annotations
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // remove overlays
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    private func drawRoute(p1: CLLocationCoordinate2D?, p2: CLLocationCoordinate2D?) {
        guard let p1 = p1, let p2 = p2 else { return }
        let directionRequest = MKDirections.Request()
        directionRequest.source = .init(placemark: .init(coordinate: p1))
        directionRequest.destination = .init(placemark: .init(coordinate: p2))
        directionRequest.transportType = .walking
                
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let route = response.routes.first else { return }
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
//            let rect = route.polyline.boundingMapRect
            
//            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
}

// MARK: - extension MapViewController (Person)

extension MapViewController {
    
    private func showPerson(_ info: PersonInfo) {
        if currentlySelectedPerson != nil {
            closePersonController()
        }
 
        personController.update(info, color: currentlySelectedRoute?.color ?? .systemBackground, closeAction: closePersonController)
        manager.show(personController, state: .middle)
        currentlySelectedPerson = info
    }
    
    private func closePersonController() {
        manager.closeCurrent()
        mapView.deselectAnnotation(currentlySelectedPerson, animated: true)
        currentlySelectedPerson = nil
    }
    
}

// MARK: - extension MapViewController

extension MapViewController {
    
    func showPlaceOnMap(
        with coordinates: CLLocationCoordinate2D,
        animated: Bool = true,
        meters: CLLocationDegrees = 800
    ) {
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: meters, longitudinalMeters: meters)
        let centerPoint = coordinateRegion.center
//        let centerYOffset = 2 * CGFloat(coordinateRegion.span.latitudeDelta) * currentBottomSheet.height(for: currentBottomSheet.position) / (height * 2)
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude)
        let newCoordinateRegion = MKCoordinateRegion(center: centerPointOfNewRegion, span: coordinateRegion.span)
        mapView.setRegion(newCoordinateRegion, animated: animated)
    }
    
}

// MARK: - protocol CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    /// move camera to current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { locationManager.stopUpdatingLocation() }
        guard let location = locations.last else { return }
        
        currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        if state == .showLocationAtFirstTime {
            showPlaceOnMap(with: location.coordinate, animated: false, meters: 3000)
        } else if state == .showCurrentLocation {
            showPlaceOnMap(with: location.coordinate)
        }
        
        state = .default
    }
    
}

// MARK: - protocol MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? PersonInfo {
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            view.displayPriority = .required
            return view
        } else
        if let userLocation = annotation as? MKUserLocation {
            userLocation.title = ""
        } else if let cluster = annotation as? MKClusterAnnotation {
            cluster.title = ""
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let info = view.annotation as? PersonInfo {
//            mapDelegate?.showPlace(place)
            showPerson(info)
        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                
                var zoomRect: MKMapRect = .null
                for annotation in cluster.memberAnnotations {
                    let annotationPoint = MKMapPoint(annotation.coordinate)
                    let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                    zoomRect = zoomRect.union(pointRect)
                }
                
                let offset = zoomRect.size.width / 2
                let origin = MKMapPoint(x: zoomRect.origin.x - offset / 2, y: zoomRect.origin.y)
                let size = MKMapSize(width: zoomRect.width + offset, height: zoomRect.height)
                zoomRect = MKMapRect(origin: origin, size: size)
                
                mapView.setVisibleMapRect(zoomRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemRed
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
