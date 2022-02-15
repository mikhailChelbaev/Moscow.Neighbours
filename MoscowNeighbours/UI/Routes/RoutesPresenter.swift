//
//  RoutesPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import UIKit

protocol RoutesEventHandler {    
    func onFetchData()
    func onRouteCellTap(route: Route)
}

class RoutesPresenter: RoutesEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RouteView?
    
    private var routesService: RoutesProvider
    private var purchaseService: PurchaseProvider
    private var userService: UserProvider
    private let routesDescriptionBuilder: RoutesDescriptionBuilder
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routesService = storage.routesService
        purchaseService = storage.purchaseService
        userService = storage.userService
        routesDescriptionBuilder = storage.routesDescriptionBuilder
        
        delayManager = DefaultDelayManager(minimumDuration: 1.0)
        
        routesService.register(WeakRef(self))
        userService.register(WeakRef(self))
    }
    
    // MARK: - RoutesEventHandler methods
    
    func onFetchData() {
        fetchRoutes()
    }
    
    func onRouteCellTap(route: Route) {
        let controller = routesDescriptionBuilder.buildRouteDescriptionViewController(route: route)
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func fetchRoutes() {
        routesService.fetchRoutes()
    }
    
    func handlerError(_ error: Error) {
        delayManager.completeWithDelay {
            self.viewController?.state = .error
            self.viewController?.reloadData()
        }
    }
}

// MARK: - protocol RouteServiceDelegate

extension RoutesPresenter: RouteServiceDelegate {
    func didStartFetchingRoutes() {
        viewController?.status = .loading
        delayManager.start()
    }
    
    func didFetchRoutes(_ routes: [Route]) {
        delayManager.completeWithDelay { [self] in
            viewController?.state = .success(routes: routes)
            viewController?.reloadData()
        }
    }
    
    func didFailWhileRoutesFetch(error: NetworkError) {
        handlerError(error)
    }
}

// MARK: - protocol UserServiceDelegate

extension RoutesPresenter: UserServiceDelegate {
    func didChangeUserModel(service: UserService) {
        fetchRoutes()
    }
}
