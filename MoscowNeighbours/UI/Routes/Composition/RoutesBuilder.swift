//
//  RoutesBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

struct RoutesStorage {
    let routesService: RoutesProvider
    let routesDescriptionBuilder: RoutesDescriptionBuilder
    let routesFetchDelayManager: DelayManager
    let userState: UserState
    
    init(routesService: RoutesProvider, routesDescriptionBuilder: RoutesDescriptionBuilder, routesFetchDelayManager: DelayManager, userState: UserState) {
        self.routesService = MainQueueDispatchDecorator(decoratee: routesService)
        self.routesDescriptionBuilder = routesDescriptionBuilder
        self.routesFetchDelayManager = routesFetchDelayManager
        self.userState = userState
    }
}

protocol RoutesBuilder {
    func buildRouteViewController(with storage: RoutesStorage) -> RouteViewController
}

extension Builder: RoutesBuilder {
    func buildRouteViewController(with storage: RoutesStorage) -> RouteViewController {
        let routesPresenter = RoutesPresenter(storage: storage)
        let viewController = RouteViewController(eventHandler: routesPresenter)
        routesPresenter.viewController = viewController
        storage.userState.register(WeakRef(routesPresenter))
        return viewController
    }
    
    func makeRoutesStorage() -> RoutesStorage {
        return RoutesStorage(routesService: routesService,
                             routesDescriptionBuilder: self,
                             routesFetchDelayManager: DefaultDelayManager(minimumDuration: 1.0),
                             userState: userState)
    }
}
