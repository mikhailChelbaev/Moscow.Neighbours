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
    private let routesDescriptionBuilder: RoutesDescriptionBuilder
    
    private let delayManager: DelayManager
    
    private var routes: [Route]
    
    // MARK: - Init
    
    init(storage: RoutesStorage) {
        routes = []
        
        routesService = storage.routesService
        purchaseService = storage.purchaseService
        routesDescriptionBuilder = storage.routesDescriptionBuilder
        
        delayManager = DefaultDelayManager(minimumDuration: 1.0)
    }
    
    // MARK: - RoutesEventHandler methods
    
    func onFetchData() {
        delayManager.start()
        Task {
            do {
                let routes = try await routesService.fetchRoutes()
                await handleRoutes(routes)
            }
            catch {
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                await handlerError(error)
            }
        }
    }
    
    func onRouteCellTap(route: Route) {
        let controller = routesDescriptionBuilder.buildRouteDescriptionViewController(route: route)
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    // MARK: - Helpers
    
    @MainActor
    func handleRoutes(_ model: [Route]) {
        routes = model
        let productIdentifiers = model.compactMap(\.purchase.productId)
        
        purchaseService.fetchProducts(productIds: Set(productIdentifiers)) { [weak self] response in
            self?.handleFetchedProducts(response)
        }
    }
    
    @MainActor
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
            
            delayManager.completeWithDelay {
                self.viewController?.state = .success(routes: self.routes)
                self.viewController?.reloadData()
            }
            
        case .failure(let error):
            Logger.log("Failed to fetch products: \(error.localizedDescription)")
            break
        }
    }
}
