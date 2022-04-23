//
//  PurchaseProductsService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import StoreKit

final class PurchaseProductsService: NSObject, PurchaseProductsProvider {
    
    typealias Result = PurchaseProductsProvider.Result
    
    private var productRequest: SKProductsRequest?
    private var productsRequestCallbacks = [(Result) -> Void]()
    
    func fetchProducts(productIds: Set<String>, completion: @escaping (Result) -> Void) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }
        
        productsRequestCallbacks.append(completion)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIds)
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
    
}

// MARK: - protocol SKProductsRequestDelegate

extension PurchaseProductsService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.isEmpty {
            Logger.log("Found 0 products")
            
        } else {
            response.products.forEach {
                Logger.log("Found product: \($0.productIdentifier)")
            }
        }
        
        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        Logger.log("Failed to load products with error:\n \(error)")
        
        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}
