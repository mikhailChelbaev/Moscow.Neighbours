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
        return manager
    }()
    
    private let routesController: RouteViewController = .init()
    
    private let routeDescriptionController: RouteDescriptionViewController = .init()
    
    private var state: State = .showLocationAtFirstTime

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
        
        addChild(routeDescriptionController)
        view.addSubview(routeDescriptionController.view)
        routeDescriptionController.view.stickToSuperviewEdges(.all)
        routeDescriptionController.drawerView.setState(.dismissed, animated: false)
        
        manager.show(routesController, state: .middle, animated: false)
    }
    
    private func registerAnnotationViews() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(PlaceClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func showRoute(_ route: Route) {
        routeDescriptionController.updateRoute(route, closeAction: closeRouteDescription)
        manager.show(routeDescriptionController, state: .middle)
        mapView.addAnnotations(route.personsInfo)
    }
    
    private func closeRouteDescription() {
        manager.closeCurrent()
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
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
        let location = locations.last! as CLLocation
        if state == .showLocationAtFirstTime {
            showPlaceOnMap(with: location.coordinate, animated: false, meters: 3000)
        } else if state == .showCurrentLocation {
            showPlaceOnMap(with: location.coordinate)
        }
        state = .default
        locationManager.stopUpdatingLocation()
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
//        if let place = view.annotation as? Place {
//            mapDelegate?.showPlace(place)
//        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                
                var zoomRect: MKMapRect = MKMapRect.null
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
//        }
    }
    
}

