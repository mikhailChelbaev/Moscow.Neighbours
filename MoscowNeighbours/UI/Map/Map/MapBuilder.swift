//
//  MapBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

struct MapStorage {
    let routesBuilder: RoutesBuilder
    let personBuilder: PersonBuilder
    
    let locationService: LocationService
    let notificationService: NotificationService
    let mapService: MapService
}

protocol MapBuilder {
    func buildMapViewController() -> MapViewController
}

extension Builder: MapBuilder {
    func buildMapViewController() -> MapViewController {
        let presenter = MapPresenter(storage: makeStorage())
        let viewController = MapViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
    private func makeStorage() -> MapStorage {
        return MapStorage(routesBuilder: self,
                          personBuilder: self,
                          locationService: locationService,
                          notificationService: NotificationService(),
                          mapService: mapService)
    }
}
