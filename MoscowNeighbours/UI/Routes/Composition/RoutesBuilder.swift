//
//  RoutesBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

public struct RoutesStorage {
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

extension Builder {
    public func makeRoutesStorage() -> RoutesStorage {
        return RoutesStorage(routesService: routesService,
                             routesDescriptionBuilder: self,
                             routesFetchDelayManager: DefaultDelayManager(minimumDuration: 1.0),
                             userState: userState)
    }
}

public final class RoutesUIComposer {
    private init() {}
    
    public static func routesComposeWith(_ storage: RoutesStorage, coordinator: RoutesCoordinator) -> RoutesViewController {
        let presenter = RoutesPresenter(
            routesService: storage.routesService,
            delayManager: storage.routesFetchDelayManager)
        
        let userStateObserver = UserStateObserver(completion: presenter.didFetchRoutes)
        let tableViewController = RoutesTableViewController(didRouteCellTap: presenter.didRouteCellTap(route:))
        
        let viewController = RoutesViewController(
            presenter: presenter,
            tableViewController: tableViewController,
            userStateObserver: userStateObserver,
            coordinator: coordinator)
        
        let weakViewController = WeakRef(viewController)
        
        presenter.routesView = RoutesViewAdapter(controller: viewController)
        presenter.routeDescriptionPresenterView = weakViewController
        presenter.routeErrorView = weakViewController
        presenter.routeLoadingView = WeakRef(tableViewController)
        
        storage.userState.register(userStateObserver)
        
        return viewController
    }
}
