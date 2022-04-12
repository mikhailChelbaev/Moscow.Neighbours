//
//  RoutePassingBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

struct RoutePassingStorage {
    let route: LegacyRouteViewModel
    let personBuilder: PersonBuilder
    let mapService: MapService
    let routePassingService: RoutePassingService
}

protocol RoutePassingBuilder {
    func buildRoutePassingViewController(route: LegacyRouteViewModel) -> RoutePassingViewController
}

extension Builder: RoutePassingBuilder {
    func buildRoutePassingViewController(route: LegacyRouteViewModel) -> RoutePassingViewController {
        let storage = RoutePassingStorage(route: route,
                                          personBuilder: self,
                                          mapService: mapService,
                                          routePassingService: routePassingService)
        let presenter = RoutePassingPresenter(storage: storage)
        let viewController = RoutePassingViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
