//
//  RouteDescriptionLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import MoscowNeighbours

final class RouteDescriptionLoaderSpy: ItemTransformer, PurchaseOperationProvider {    
    
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
    
    var purchaseCompletions = [String: (PurchaseOperationProvider.Result) -> Void]()

    func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
        purchaseCompletions[product.id] = completion
    }

    func restorePurchases(completion: @escaping (PurchaseOperationProvider.Result) -> Void) {

    }

    func completePurchaseSuccessfully(for product: String?) {
        purchaseCompletions[product ?? ""]?(.success(true))
    }
    
}
