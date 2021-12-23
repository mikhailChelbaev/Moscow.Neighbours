//
//  RouteDescriptionBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController
}

extension Builder: RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController {
        let presenter = RouteDescriptionPresenter(route: route)
        let viewController = RouteDescriptionViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }    
}
