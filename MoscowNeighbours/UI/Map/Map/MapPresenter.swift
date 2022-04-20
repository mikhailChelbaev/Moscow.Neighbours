//
//  MapPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit
import MapKit

protocol MapEventHandler: AnyObject {
    func onViewDidLoad()
    func onViewDidAppear()
    func onAnnotationSelection(_ view: MKAnnotationView)
    func onLocationButtonTap()
    func onMenuButtonTap()
}

class MapPresenter: MapEventHandler {
    
    // MARK: - LocationState
    
    enum LocationState {
        case showLocationAtFirstTime
        case showCurrentLocation
        case `default`
    }
    
    // MARK: - Properties
    
    weak var viewController: MapView?
    
    private let coordinator: MapCoordinator
    
    private var locationService: LocationService
    private var mapService: MapService
    private let routePassingService: RoutePassingService
    
    private var locationState: LocationState
    
    private var annotationSelectedProgrammatically = false
    
    // MARK: - Init
    
    init(storage: MapStorage, coordinator: MapCoordinator) {
        self.coordinator = coordinator
        
        locationService = storage.locationService
        mapService = storage.mapService
        routePassingService = storage.routePassingService
        
        locationState = .showLocationAtFirstTime
        
        locationService.register(WeakRef(self))
        mapService.register(WeakRef(self))
    }
    
    // MARK: - MapEventHandler methods
    
    func onViewDidLoad() {
        locationService.requestAuthorization()
        locationService.requestLocationUpdate()        
    }
    
    func onViewDidAppear() {
        viewController?.displayRoutes()
    }
    
    func onLocationButtonTap() {
        locationState = .showCurrentLocation
        locationService.requestLocationUpdate()
    }
    
    func onMenuButtonTap() {
        guard let topController = viewController?.getTopController() else {
            return
        }
        
//        let controller = menuBuilder.buildMenuViewController()
//        topController.present(controller, state: .top, completion: nil)
    }
    
    func onAnnotationSelection(_ view: MKAnnotationView) {
        mapService.didSelectAnnotation(view)
        
        guard !annotationSelectedProgrammatically else {
            annotationSelectedProgrammatically = false
            return
        }
        
        if let person = view.annotation as? PersonInfo {
            let presentationState: PersonPresentationState = routePassingService.isPassingRoute ?
                .fullDescription :
                .shortDescription
            coordinator.displayPerson(person, presentationState: presentationState)
        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                viewController?.zoomAnnotations(cluster.memberAnnotations)
            }
        }
    }
    
    func centerAnnotation(_ annotation: MKAnnotation) {
        viewController?.showPlaceOnMap(with: annotation.coordinate, animated: true, meters: 800)
    }
    
}

extension MapPresenter: LocationServiceOutput {
    func didUpdateLocation(location: CLLocation) {
        defer {
            locationState = .default
        }

        if locationState == .showLocationAtFirstTime {
            viewController?.showPlaceOnMap(with: location.coordinate,
                                           animated: false,
                                           meters: 3000)
        } else if locationState == .showCurrentLocation {
            viewController?.showPlaceOnMap(with: location.coordinate,
                                           animated: true,
                                           meters: 800)
        }
    }
    
    func didFailWithError(error: Error) {
        locationState = .default
    }
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) { }
    
    func didEnterNewRegions(_ regions: [CLRegion]) { }
    
    func didChangeAuthorization() {
        locationState = .showLocationAtFirstTime
        locationService.requestLocationUpdate()
    }
}

extension MapPresenter: MapServiceOutput {
    func showAnnotations(_ annotations: [MKAnnotation]) {
        viewController?.showAnnotations(annotations)
        viewController?.zoomAnnotations(annotations)
    }
    
    func addOverlays(_ overlays: [MKOverlay]) {
        viewController?.addOverlays(overlays)
    }
    
    func removeAnnotations(_ annotations: [MKAnnotation]) {
        viewController?.removeAnnotations(annotations)
    }
    
    func removeOverlays(_ overlays: [MKOverlay]) {
        viewController?.removeOverlays(overlays)
    }
    
    func selectAnnotation(_ annotation: MKAnnotation) {
        annotationSelectedProgrammatically = true
        viewController?.selectAnnotation(annotation)
    }
    
    func deselectAnnotation(_ annotation: MKAnnotation) {
        viewController?.deselectAnnotation(annotation)
    }
    
    func didSelectAnnotation(_ view: MKAnnotationView) { }
}
