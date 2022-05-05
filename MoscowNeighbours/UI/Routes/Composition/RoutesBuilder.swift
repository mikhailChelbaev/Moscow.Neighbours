//
//  RoutesBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

public struct RoutesStorage {
    let routesService: RoutesProvider
    let routesStateObserver: RoutesStateObserver
    let routesFetchDelayManager: DelayManager
    let userState: UserState

    init(routesService: RoutesProvider, routesStateObserver: RoutesStateObserver, routesFetchDelayManager: DelayManager, userState: UserState) {
        self.routesService = routesService
        self.routesStateObserver = routesStateObserver
        self.routesFetchDelayManager = routesFetchDelayManager
        self.userState = userState
    }
}

extension Builder {
    public func makeRoutesStorage() -> RoutesStorage {
        return RoutesStorage(routesService: routesService,
                             routesStateObserver: routesService,
                             routesFetchDelayManager: DefaultDelayManager(minimumDuration: 1.0),
                             userState: userState)
    }
}

public final class RoutesUIComposer {
    private init() {}
    
    public static func routesComposeWith(_ storage: RoutesStorage, coordinator: RoutesCoordinator) -> RoutesViewController {
        let presenter = RoutesPresenter(
            routesService: MainQueueDispatchDecorator(decoratee: storage.routesService),
            routesStateObserver: storage.routesStateObserver,
            delayManager: storage.routesFetchDelayManager)
        
        let userStateObserver = UserStateObserver(completion: { [weak presenter] in
            presenter?.didFetchRoutes()
        })
        let tableViewController = RoutesTableViewController(didRouteCellTap: presenter.didRouteCellTap(route:))
        
        let viewController = RoutesViewController(
            presenter: presenter,
            tableViewController: tableViewController,
            coordinator: coordinator)
        
        let weakViewController = WeakRef(viewController)
        
        presenter.routesView = RoutesViewAdapter(controller: viewController)
        presenter.routeDescriptionPresenterView = weakViewController
        presenter.routeErrorView = weakViewController
        presenter.routeLoadingView = WeakRef(tableViewController)
        
        storage.userState.register(MainQueueDispatchDecorator(decoratee: userStateObserver))
        
        return viewController
    }
}
