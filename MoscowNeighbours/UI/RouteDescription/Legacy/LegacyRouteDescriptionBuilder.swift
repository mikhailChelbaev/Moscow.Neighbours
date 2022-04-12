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
    let routePurchaseConfirmationService: RoutePurchaseConfirmationProvider
    let routesService: RoutesProvider
}

protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> LegacyRouteDescriptionViewController
}

extension Builder: RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController(route: Route) -> LegacyRouteDescriptionViewController {
        let presenter = LegacyRouteDescriptionPresenter(storage: buildStorage(route: route))
        let viewController = LegacyRouteDescriptionViewController(eventHandler: presenter)
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
                                purchaseService: purchaseService,
                                routePurchaseConfirmationService: RoutePurchaseConfirmationService(api: api),
                                routesService: routesService)
    }
}
