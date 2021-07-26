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
    
    private let map: MKMapView = {
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
        let controllers: [BottomSheetViewController] = [routesController, routeDescriptionController]
        let manager = BottomSheetsManager(controllers: controllers, presenter: self)
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
        
        routesController.showRouteCompletion = showRoute(_:)
        
        view.addSubview(map)
        map.stickToSuperviewEdges(.all)
        
        addChild(routesController)
        view.addSubview(routesController.view)
        routesController.view.stickToSuperviewEdges(.all)
        
        addChild(routeDescriptionController)
        view.addSubview(routeDescriptionController.view)
        routeDescriptionController.view.stickToSuperviewEdges(.all)
        routeDescriptionController.drawerView.setState(.dismissed, animated: false)
        
        view.bringSubviewToFront(routesController.view)
    }
    
    private func showRoute(_ route: Route) {
        routeDescriptionController.updateRoute(route, closeAction: closeRouteDescription)
        manager.show(routeDescriptionController, state: .middle, states: [.middle, .top])
    }
    
    private func closeRouteDescription() {
        manager.show(routesController, state: .middle)
    }
    
}

extension MapViewController {
    
    func showPlaceOnMap(with coordinates: CLLocationCoordinate2D, animated: Bool = true, meters: CLLocationDegrees = 800) {
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: meters, longitudinalMeters: meters)
        let centerPoint = coordinateRegion.center
//        let centerYOffset = 2 * CGFloat(coordinateRegion.span.latitudeDelta) * currentBottomSheet.height(for: currentBottomSheet.position) / (height * 2)
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude)
        let newCoordinateRegion = MKCoordinateRegion(center: centerPointOfNewRegion, span: coordinateRegion.span)
        map.setRegion(newCoordinateRegion, animated: animated)
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

