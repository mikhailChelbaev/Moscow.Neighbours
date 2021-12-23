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
}

protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController
}

extension Builder: RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController {
        let storage = RouteDescriptionStorage(route: route, personBuilder: self)
        let presenter = RouteDescriptionPresenter(storage: storage)
        let viewController = RouteDescriptionViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }    
}
