//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.12.2021.
//

import Foundation

protocol RouteDescriptionEventHandler: AnyObject {
    func getRoute() -> Route
    func onBackButtonTap()
}

class RouteDescriptionPresenter: RouteDescriptionEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RouteDescriptionView?
    
    private let route: Route
    
    // MARK: - Init
    
    init(route: Route) {
        self.route = route
//        routesService = service
//        routesService.register(WeakRef(self))
    }
    
    // MARK: - RoutesEventHandler methods
    
    func getRoute() -> Route {
        return route
    }
    
    func onBackButtonTap() {
        
    }
    
}
