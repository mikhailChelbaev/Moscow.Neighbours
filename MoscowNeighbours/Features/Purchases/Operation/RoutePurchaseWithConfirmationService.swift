//
//  RoutePurchaseWithConfirmationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import Foundation

public protocol PurchaseWithConfirmationProvider {
    typealias Result = Swift.Result<Void, Error>
    
    func purchaseRoute(route: Route, completion: @escaping (Result) -> Void)
}

public final class RoutePurchaseWithConfirmationService: PurchaseWithConfirmationProvider {
    private let operation: PurchaseOperationProvider
    private let confirmation: RoutePurchaseConfirmationProvider
    
    public init(operation: PurchaseOperationProvider, confirmation: RoutePurchaseConfirmationProvider) {
        self.operation = operation
        self.confirmation = confirmation
    }
    
    public typealias Result = PurchaseWithConfirmationProvider.Result
    private struct MissingProduct: Error {}
    
    public func purchaseRoute(route: Route, completion: @escaping (Result) -> Void) {
        guard let product = route.purchase.product else {
            return completion(.failure(MissingProduct()))
        }
        
        operation.purchaseProduct(product: product) { [weak self] result in
            if case Result.success = result {
                self?.confirmation.confirmRoutePurchase(routeId: route.id, completion: nil)
            }
        }
    }
}
