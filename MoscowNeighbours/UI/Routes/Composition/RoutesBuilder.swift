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
        let presenter = RoutesPresenter(
            routesService: storage.routesService,
            delayManager: storage.routesFetchDelayManager)
        
        let userStateObserver = UserStateObserver(completion: presenter.didFetchRoutes)
        let tableViewController = RouteTableViewController(didRouteCellTap: presenter.didRouteCellTap(route:))
        
        let viewController = RouteViewController(
            presenter: presenter,
            tableViewController: tableViewController,
            userStateObserver: userStateObserver,
            routeDescriptionController: { [unowned self] route in
                self.buildRouteDescriptionViewController(route: route)
            })
        
        let weakViewController = WeakRef(viewController)
        
        presenter.routesView = RoutesViewAdapter(controller: viewController)
        presenter.routeDescriptionPresenterView = weakViewController
        presenter.routeErrorView = weakViewController
        presenter.routeLoadingView = WeakRef(tableViewController)
        
        storage.userState.register(userStateObserver)
        
        return viewController
    }
    
    func makeRoutesStorage() -> RoutesStorage {
        return RoutesStorage(routesService: routesService,
                             routesDescriptionBuilder: self,
                             routesFetchDelayManager: DefaultDelayManager(minimumDuration: 1.0),
                             userState: userState)
    }
}

