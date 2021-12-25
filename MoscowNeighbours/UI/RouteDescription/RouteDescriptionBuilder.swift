//
//  RouteDescriptionBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

struct RouteDescriptionStorage {
    let route: Route
    let personBuilder: PersonBuilder
    let routePassingBuilder: RoutePassingBuilder
    let mapService: MapService
}

protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController
}

extension Builder: RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController {
        let storage = RouteDescriptionStorage(route: route,
                                              personBuilder: self,
                                              routePassingBuilder: self,
                                              mapService: mapService)
        let presenter = RouteDescriptionPresenter(storage: storage)
        let viewController = RouteDescriptionViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }    
}
