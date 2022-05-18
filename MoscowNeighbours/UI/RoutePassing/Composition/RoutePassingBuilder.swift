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
    let achievementsSaver: AchievementsSaver
}

protocol RoutePassingBuilder {
    func buildRoutePassingViewController(route: Route) -> RoutePassingViewController
}

extension Builder: RoutePassingBuilder {
    func buildRoutePassingViewController(route: Route) -> RoutePassingViewController {
        let storage = RoutePassingStorage(
            route: route,
            mapService: mapService,
            routePassingService: routePassingService,
            achievementsSaver: achievementsService)
        let presenter = RoutePassingPresenter(storage: storage)
        let viewController = RoutePassingViewController(eventHandler: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
