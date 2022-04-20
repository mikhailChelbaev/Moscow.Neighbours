//
//  RoutePassingBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

struct RoutePassingStorage {
    let persons: [PersonInfo]
    let mapService: MapService
    let routePassingService: RoutePassingService
}

protocol RoutePassingBuilder {
    func buildRoutePassingViewController(persons: [PersonInfo]) -> RoutePassingViewController
}

extension Builder: RoutePassingBuilder {
    func buildRoutePassingViewController(persons: [PersonInfo]) -> RoutePassingViewController {
        let storage = RoutePassingStorage(persons: persons,
                                          mapService: mapService,
                                          routePassingService: routePassingService)
        let presenter = RoutePassingPresenter(storage: storage)
        let viewController = RoutePassingViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
