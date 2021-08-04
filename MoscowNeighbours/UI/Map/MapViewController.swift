//
//  MapViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.07.2021.
//

import UIKit
import MapKit

protocol MapPresentable: AnyObject {
    var mapView: MKMapView { get }
}

final class MapViewController: UIViewController, MapPresentable {
    
    enum State {
        case showLocationAtFirstTime
        case showCurrentLocation
        case `default`
    }
    
    private enum Settings {
        static let buttonSide: CGFloat = 48
        static let locationButtonTopInset: CGFloat = 40
        static let buttonsTrailingInset: CGFloat = 20
        static let buttonsSpacing: CGFloat = 20
    }
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        return map
    }()
    
    private var locationButton: UIButton!
    
    private var cameraButton: UIButton!
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }()
    
    private lazy var manager: BottomSheetsManager = {
        let manager = BottomSheetsManager(presenter: self)
        manager.addController(routesController)
        manager.addController(routeDescriptionController)
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
    
    override func loadView() {
        view = mapView
        locationButton = createButton(image: UIImage(systemName: "location.fill"))
        cameraButton = createButton(image: UIImage(systemName: "camera.fill"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerAnnotationViews()
        commonInit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        locationButton.layer.shadowColor = UIColor.shadow.cgColor
        cameraButton.layer.shadowColor = UIColor.shadow.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        locationButton.updateShadowPath()
        cameraButton.updateShadowPath()
    }
    
    private func commonInit() {
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        
        routesController.showRouteCompletion = showRoute(_:)
        routeDescriptionController.mapPresenter = self
        
        locationButton.addTarget(self, action: #selector(updateCurrentLocation), for: .touchUpInside)
        cameraButton.isEnabled = false
        
        view.addSubview(cameraButton)
        cameraButton.stickToSuperviewSafeEdges([.top, .right], insets: .init(top: Settings.locationButtonTopInset, left: 0, bottom: 0, right: Settings.buttonsTrailingInset))
        cameraButton.exactSize(.init(width: Settings.buttonSide, height: Settings.buttonSide))
        
        view.addSubview(locationButton)
        locationButton.trailing(Settings.buttonsTrailingInset)
        locationButton.top(Settings.buttonsSpacing, to: cameraButton)
        locationButton.exactSize(.init(width: Settings.buttonSide, height: Settings.buttonSide))
        
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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
}

// MARK: - extension MapViewController (buttons)

extension MapViewController {
    
    private func createButton(image: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = Settings.buttonSide / 2
        button.addShadow()
        return button
    }
    
    @objc private func updateCurrentLocation() {
        state = .showCurrentLocation
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: - extension MapViewController (Route)

extension MapViewController {
    
    private func showRoute(_ route: Route) {
        currentlySelectedRoute = route
        
        routeDescriptionController.updateRoute(route, closeAction: closeRouteDescription)
        manager.show(routeDescriptionController, state: .bottom)
        mapView.addAnnotations(route.personsInfo)
        
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
        
        zoomAnnotations(route.personsInfo)
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
    
    func showPerson(_ info: PersonInfo) {
        if currentlySelectedPerson != nil {
            closePersonController()
        }
        currentlySelectedPerson = info
 
        personController.update(info, color: currentlySelectedRoute?.color ?? .systemBackground, closeAction: closePersonController)
        manager.show(personController, state: .middle)
        showPlaceOnMap(with: info.coordinates)
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
        
        var centerYOffset: Double = 0
        if manager.currentController?.drawerView.state == .middle {
            centerYOffset = coordinateRegion.span.latitudeDelta * Double(BottomSheetViewController.Settings.middleInsetFromBottom) / Double(UIScreen.main.bounds.height)
        }
        
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPoint.latitude - Double(centerYOffset), centerPoint.longitude)
        let newCoordinateRegion = MKCoordinateRegion(center: centerPointOfNewRegion, span: coordinateRegion.span)
        mapView.setRegion(newCoordinateRegion, animated: animated)
    }
    
    private func zoomAnnotations(_ annotations: [MKAnnotation]) {
        var zoomRect: MKMapRect = .null
        for annotation in annotations {
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
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as! MKMarkerAnnotationView
            view.displayPriority = .required
            view.markerTintColor = currentlySelectedRoute?.color
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let info = view.annotation as? PersonInfo {
            showPerson(info)
        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                zoomAnnotations(cluster.memberAnnotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = currentlySelectedRoute?.color
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
