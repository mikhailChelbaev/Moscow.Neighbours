//
//  RoutesBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

struct RoutesStorage {
    let routesService: RoutesService
    let routesDescriptionBuilder: RoutesDescriptionBuilder
}

protocol RoutesBuilder {
    func buildRouteViewController() -> RouteViewController
}

extension Builder: RoutesBuilder {
    func buildRouteViewController() -> RouteViewController {
        let routesPresenter = RoutesPresenter(storage: makeStorage())
        let viewController = RouteViewController(eventHandler: routesPresenter)
        routesPresenter.viewController = viewController
        return viewController
    }
    
    private func makeStorage() -> RoutesStorage {
        return RoutesStorage(routesService: .init(api: requestsFactory),
                             routesDescriptionBuilder: self)
    }    
}
