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
    func didSelectAnnotation(_ view: MKAnnotationView)
    func onLocationButtonTap()
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
    
    private let routesBuilder: RoutesBuilder
    private let personBuilder: PersonBuilder
    
    private var locationService: LocationService
    private let notificationService: NotificationService
    private var mapService: MapService
    
    private var locationState: LocationState
    
    // MARK: - Init
    
    init(storage: MapStorage) {
        routesBuilder = storage.routesBuilder
        personBuilder = storage.personBuilder
        
        locationService = storage.locationService
        notificationService = storage.notificationService
        mapService = storage.mapService
        
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
        let controller = routesBuilder.buildRouteViewController()
        viewController?.present(controller, state: .middle, completion: nil)
    }
    
    func onLocationButtonTap() {
        locationState = .showCurrentLocation
        locationService.requestLocationUpdate()
    }
    
    func didSelectAnnotation(_ view: MKAnnotationView) {
        if let personInfo = view.annotation as? PersonInfo {
            let controller = viewController?.getTopController()
            if let personController = controller as? PersonViewController {
                personController.updatePerson(personInfo: personInfo)
            } else {
                let personViewController = personBuilder.buildPersonViewController(personInfo: personInfo,
                                                                                       userState: .default)
                controller?.present(personViewController, state: .top, completion: nil)
            }
        } else {
            if let cluster = view.annotation as? MKClusterAnnotation {
                viewController?.zoomAnnotations(cluster.memberAnnotations)
            }
        }
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
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) {
//        var personsInfo: [PersonInfo] = []
//        for info in currentlySelectedRoute?.personsInfo ?? [] {
//            for region in regions {
//                if info.coordinate == (region as? CLCircularRegion)?.center {
//                    personsInfo.append(info)
//                }
//            }
//        }
//        if currentlySelectedPerson != nil {
//            personController.update()
//        }
//        routePassing.update()
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
//        let personsInfo: [PersonInfo] = regions.compactMap { region in
//            for info in currentlySelectedRoute?.personsInfo ?? [] {
//                if info.coordinate == (region as? CLCircularRegion)?.center {
//                    return info
//                }
//            }
//            return nil
//        }
//        visitedPersons.append(contentsOf: personsInfo)
//
//        if let personInfo = personsInfo.first {
//            routePassing.scrollToPerson(personInfo)
//            notificationService.fireNotification(title: personInfo.person.name) { [weak self] in
//                self?.showPerson(personInfo, state: .top)
//            }
//        }
    }
    
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
}
