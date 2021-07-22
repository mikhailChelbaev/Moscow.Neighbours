//
//  MapViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.07.2021.
//

import UIKit
import MapKit
import UltraDrawerView

class MapViewController: UIViewController {
    
    enum State {
        case showFirstTime
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
    
    private let routeController: RouteViewController = .init()
    
    private var state: State = .showFirstTime

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        locationManager.startUpdatingLocation()
        
        addChild(routeController)
        
        view.addSubview(map)
        map.stickToSuperviewEdges(.all)
        
        view.addSubview(routeController.view)
        routeController.view.stickToSuperviewEdges(.all)
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
        if state == .showFirstTime {
            showPlaceOnMap(with: location.coordinate, animated: false, meters: 3000)
        } else if state == .showCurrentLocation {
            showPlaceOnMap(with: location.coordinate)
        }
        state = .default
        locationManager.stopUpdatingLocation()
    }
    
}

