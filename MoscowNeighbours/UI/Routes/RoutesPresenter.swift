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
    
    private var routes: [Route]
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routes = []
        
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
    
    func handleRoutes(_ model: [Route]) {
        routes = model
        let productIdentifiers = model.compactMap(\.purchase.productId)
        
        purchaseService.fetchProducts(productIds: Set(productIdentifiers)) { [weak self] response in
            self?.handleFetchedProducts(response)
        }
    }
    
    func handlerError(_ error: Error) {
        delayManager.completeWithDelay {
            self.viewController?.state = .error
            self.viewController?.reloadData()
        }
    }
    
    func handleFetchedProducts(_ response: RequestProductsResult) {
        switch response {
        case .success(let products):
            routes = routes.map({ route in
                let copy = route
                copy.price = products.first?.localizedPrice ?? ""
                return copy
            })
            
        case .failure(let error):
            Logger.log("Failed to fetch products: \(error.localizedDescription)")
            routes = routes.filter({ $0.purchase.status != .buy })
        }
        
        delayManager.completeWithDelay {
            self.viewController?.state = .success(routes: self.routes)
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
        handleRoutes(routes)
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
