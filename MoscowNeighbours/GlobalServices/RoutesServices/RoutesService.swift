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
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory, purchaseService: PurchaseProvider) {
        self.api = api
        self.purchaseService = purchaseService
    }
    
    // MARK: - Internal Methods
    
    
    func fetchRoutes(completion: @escaping (RoutesService.Result) -> Void) {
        Task {
            let result = await requestSender.send(request: api.routesRequest, type: [Route].self)
            
            switch result {
            case .success(let model):
                fetchProducts(model, completion: completion)
                
            case .failure(let error):
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchProducts(_ routes: [Route], completion: @escaping (RoutesService.Result) -> Void) {
        let productIdentifiers = routes.compactMap(\.purchase.productId)
        
        purchaseService.fetchProducts(productIds: Set(productIdentifiers)) { [weak self] response in
            self?.handleFetchedProducts(response: response, routes: routes, completion: completion)
        }
    }
    
    private func handleFetchedProducts(response: RequestProductsResult, routes model: [Route], completion: @escaping (RoutesService.Result) -> Void) {
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
            completion(.success(routes))
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var routesRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/routes", method: .get)
    }
}
