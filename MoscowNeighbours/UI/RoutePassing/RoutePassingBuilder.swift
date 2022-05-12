//
//  RoutePassingBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

struct RoutePassingStorage {
    let route: Route
    let mapService: MapService
    let routePassingService: RoutePassingService
}

protocol RoutePassingBuilder {
    func buildRoutePassingViewController(route: Route) -> RoutePassingViewController
}

extension Builder: RoutePassingBuilder {
    func buildRoutePassingViewController(route: Route) -> RoutePassingViewController {
        let storage = RoutePassingStorage(route: route,
                                          mapService: mapService,
                                          routePassingService: routePassingService)
        let presenter = RoutePassingPresenter(storage: storage)
        let viewController = RoutePassingViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
