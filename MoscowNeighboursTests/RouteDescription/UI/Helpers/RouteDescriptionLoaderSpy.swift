//
//  RouteDescriptionLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import MoscowNeighbours

final class RouteDescriptionLoaderSpy: ItemTransformer, PurchaseWithConfirmationProvider {
    
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
    
    var purchaseCompletions = [(PurchaseWithConfirmationProvider.Result) -> Void]()
    
    func purchaseRoute(route: Route, completion: @escaping (PurchaseWithConfirmationProvider.Result) -> Void) {
        purchaseCompletions.append(completion)
    }

    func completePurchaseSuccessfully(at index: Int = 0) {
        purchaseCompletions[index](.success(()))
    }
    
}
