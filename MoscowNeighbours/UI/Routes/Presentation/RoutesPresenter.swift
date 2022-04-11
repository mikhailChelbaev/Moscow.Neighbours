//
//  RoutesPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

protocol RoutesView: AnyObject {
    func display(routes: [Route])
}

protocol RouteDescriptionPresenterView: AnyObject {
    func presentRouteDescription(for route: Route)
}

protocol RouteErrorView: AnyObject {
    func display(error: Error)
}

protocol RouteLoadingView: AnyObject {
    func display(isLoading: Bool)
}

final class RoutesPresenter {
    
    var routesView: RoutesView?
    var routeDescriptionPresenterView: RouteDescriptionPresenterView?
    var routeErrorView: RouteErrorView?
    var routeLoadingView: RouteLoadingView?
    
    private var routesService: RoutesProvider
    private let delayManager: DelayManager
    
    init(routesService: RoutesProvider, delayManager: DelayManager) {
        self.routesService = routesService
        self.delayManager = delayManager
    }
    
    var headerTitle: String {
        return "route.routes".localized
    }
    
    func didFetchRoutes() {
        fetchRoutes()
    }
    
    func didRouteCellTap(route: Route) {
        routeDescriptionPresenterView?.presentRouteDescription(for: route)
    }
    
    private func fetchRoutes() {
        routeLoadingView?.display(isLoading: true)
        delayManager.start()
        
        routesService.fetchRoutes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(routes):
                self.delayManager.completeWithDelay {
                    self.routesView?.display(routes: routes)
                }
                
            case let .failure(error):
                self.delayManager.completeWithDelay {
                    self.routeErrorView?.display(error: error)
                }
            }
            
            self.routeLoadingView?.display(isLoading: false)
        }
    }
}
