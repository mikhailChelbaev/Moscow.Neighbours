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
    
    private var routesService: RoutesService
    private let routesDescriptionBuilder: RoutesDescriptionBuilder
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routesService = storage.routesService
        routesDescriptionBuilder = storage.routesDescriptionBuilder
        
        delayManager = DefaultDelayManager(minimumDuration: 1.0)
        
        routesService.register(WeakRef(self))
    }
    
    // MARK: - RoutesEventHandler methods
    
    func onFetchData() {
        delayManager.start()
        routesService.fetchRoutes()
    }
    
    func onRouteCellTap(route: Route) {
        let controller = routesDescriptionBuilder.buildRouteDescriptionViewController(route: route)
        viewController?.present(controller, state: .top, completion: nil)
    }
}

// MARK: - Protocol RoutesServiceOutput

extension RoutesPresenter: RoutesServiceOutput {
    func fetchDataSucceeded(_ model: [Route]) {
        delayManager.completeWithDelay {
            self.viewController?.state = .success(routes: model)
            self.viewController?.reloadData()
        }
    }
    
    func fetchDataFailed(_ error: NetworkError) {
        delayManager.completeWithDelay {
            self.viewController?.state = .error(error: error)
            self.viewController?.reloadData()
        }
    }
}
