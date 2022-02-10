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
    let accountConfirmationBuilder: AccountConfirmationBuilder
    let authorizationBuilder: AuthorizationBuilder
    let mapService: MapService
    let purchaseService: PurchaseProvider
}

protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController
}

extension Builder: RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> RouteDescriptionViewController {
        let presenter = RouteDescriptionPresenter(storage: buildStorage(route: route))
        let viewController = RouteDescriptionViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage(route: Route) -> RouteDescriptionStorage {
        RouteDescriptionStorage(route: route,
                                personBuilder: self,
                                routePassingBuilder: self,
                                accountConfirmationBuilder: self,
                                authorizationBuilder: self,
                                mapService: mapService,
                                purchaseService: purchaseService)
    }
}
