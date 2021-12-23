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
    
    private let routesService: RoutesService
    private let routesDescriptionBuilder: RoutesDescriptionBuilder
    
    private let minimumFetchingDuration: TimeInterval = 1.0
    private var startFetchingDate: Date = .init()
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routesService = storage.routesService
        routesDescriptionBuilder = storage.routesDescriptionBuilder
        
        routesService.register(WeakRef(self))
    }
    
    // MARK: - RoutesEventHandler methods
    
    func onFetchData() {
        startFetchingDate = .init()
        routesService.fetchRoutes()
    }
    
    func onRouteCellTap(route: Route) {
        let controller = routesDescriptionBuilder.buildRouteDescriptionViewController(route: route)
        viewController?.present(controller, state: .top, completion: nil)
    }
}

// MARK: - Protocol RoutesServiceOutput

extension RoutesPresenter: RoutesServiceOutput {
    private func completeWithDelay(_ completion: Action?) {
        let delay: TimeInterval = max(0, minimumFetchingDuration - Date().timeIntervalSince(startFetchingDate))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion?()
        }
    }
    
    func fetchDataSucceeded(_ model: [Route]) {
        completeWithDelay {
            self.viewController?.state = .success(routes: model)
            self.viewController?.reloadData()
        }
    }
    
    func fetchDataFailed(_ error: NetworkError) {
        completeWithDelay {
            self.viewController?.state = .error(error: error)
            self.viewController?.reloadData()
        }
    }
}
