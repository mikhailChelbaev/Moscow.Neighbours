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
    private var userState: UserState
    private let routesDescriptionBuilder: RoutesDescriptionBuilder
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routesService = storage.routesService
        userState = storage.userState
        routesDescriptionBuilder = storage.routesDescriptionBuilder
        
        delayManager = DefaultDelayManager(minimumDuration: 1.0)
        
        userState.register(WeakRef(self))
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
        viewController?.status = .loading
        delayManager.start()
        
        routesService.fetchRoutes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let routes):
                self.delayManager.completeWithDelay {
                    self.viewController?.state = .success(routes: routes)
                    self.viewController?.reloadData()
                }
                
            case .failure(let error):
                self.handlerError(error)
            }
        }
    }
    
    func handlerError(_ error: Error) {
        delayManager.completeWithDelay {
            self.viewController?.state = .error
            self.viewController?.reloadData()
        }
    }
}

// MARK: - protocol UserServiceDelegate

extension RoutesPresenter: UserStateDelegate {
    func didChangeUserModel(state: UserState) {
        DispatchQueue.main.async { [self] in
            fetchRoutes()
        }
    }
}
