//
//  RouteDescriptionLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import MoscowNeighbours

final class RouteDescriptionLoaderSpy: ItemTransformer {
    
    // MARK: - Route Transformer
    
    var transformationCompletions = [(RouteViewModel) -> Void]()
    
    var transfromCallCount: Int {
        return transformationCompletions.count
    }
    
    func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
        transformationCompletions.append(completion)
    }
    
    func completeRoutesTransforming(with route: RouteViewModel, at index: Int = 0) {
        transformationCompletions[index](route)
    }
    
    // MARK: - Purchase Provider
    
//    var purchaseCompletions = [String: PurchaseProductCompletion]()
//
//    func fetchProducts(productIds: Set<String>, completion: @escaping RequestProductsCompletion) {
//
//    }
//
//    func purchaseProduct(productId: String, completion: @escaping PurchaseProductCompletion) {
//        purchaseCompletions[productId] = completion
//    }
//
//    func restorePurchases(completion: @escaping PurchaseProductCompletion) {
//
//    }
//
//    func completePurchaseSuccessfully(for product: String?) {
//        purchaseCompletions[product ?? ""]?(.success(true))
//    }
    
}
