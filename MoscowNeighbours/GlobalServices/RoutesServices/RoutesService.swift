//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

final class RoutesService: BaseNetworkService, RoutesProvider {
    
    // MARK: - Properties
    
    private let api: ApiRequestsFactory
    private let purchaseService: PurchaseProvider
    var observers: [String : RouteServiceDelegate]
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory, purchaseService: PurchaseProvider) {
        self.api = api
        self.purchaseService = purchaseService
        self.observers = [:]
    }
    
    // MARK: - Internal Methods
    
    func fetchRoutes() {
        observers.forEach({ $0.value.didStartFetchingRoutes() })
        Task.detached { [self] in
            let result = await requestSender.send(request: api.routesRequest,
                                                  type: [Route].self)
            switch result {
            case .success(let model):
                fetchProducts(model)
                
            case .failure(let error):
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    observers.forEach({ $0.value.didFailWhileRoutesFetch(error: error) })
                }
            }
        }
    }
    
    private func fetchProducts(_ routes: [Route]) {
        let productIdentifiers = routes.compactMap(\.purchase.productId)
        
        purchaseService.fetchProducts(productIds: Set(productIdentifiers)) { [weak self] response in
            self?.handleFetchedProducts(response: response, routes: routes)
        }
    }
    
    private func handleFetchedProducts(response: RequestProductsResult, routes model: [Route]) {
        var routes = model
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
        
        DispatchQueue.main.async {
            self.observers.forEach({ $0.value.didFetchRoutes(routes) })
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var routesRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/routes", method: .get)
    }
}
