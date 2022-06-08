//
//  RouteDescriptionLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import Foundation
import MoscowNeighbours

final class RouteDescriptionLoaderSpy: MarkdownTransformer, PurchaseRouteProvider {
    
    // MARK: - Route Transformer
    
    var transformationCompletions = [(NSAttributedString) -> Void]()
    
    var transfromCallCount: Int {
        return transformationCompletions.count
    }
    
    func transform(_ markdown: String, completion: @escaping (NSAttributedString) -> Void) {
        transformationCompletions.append(completion)
    }
    
    func completeRoutesTransforming(with text: NSAttributedString, at index: Int = 0) {
        transformationCompletions[index](text)
    }
    
    func completeRouteTransformingSuccessfully(at index: Int = 0) {
        transformationCompletions[index](NSAttributedString(string: ""))
    }
    
    // MARK: - Purchase Provider
    
    var purchaseCompletions = [(PurchaseRouteProvider.Result) -> Void]()
    
    func purchaseRoute(route: Route, completion: @escaping (PurchaseRouteProvider.Result) -> Void) {
        purchaseCompletions.append(completion)
    }

    func completePurchaseSuccessfully(at index: Int = 0) {
        purchaseCompletions[index](.success(()))
    }
    
    func completePurchase(with error: Error, at index: Int = 0) {
        purchaseCompletions[index](.failure(error))
    }
    
}
