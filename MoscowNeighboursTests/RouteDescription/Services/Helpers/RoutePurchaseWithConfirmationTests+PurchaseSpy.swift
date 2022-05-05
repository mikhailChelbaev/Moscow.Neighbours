//
//  PurchaseRouteCompositionServiceTests+PurchaseSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 24.04.2022.
//

import MoscowNeighbours

extension PurchaseRouteCompositionServiceTests {
    
    final class PurchaseSpy: PurchaseOperationProvider, RoutePurchaseConfirmationProvider, RoutesState {
        
        // MARK: - Purchase Operation
        
        private(set) var purchaseCompletions = [(PurchaseOperationProvider.Result) -> Void]()
        
        var operationCallCount: Int {
            purchaseCompletions.count
        }
        
        func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
            purchaseCompletions.append(completion)
        }
        
        func restorePurchases(completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
            
        }
        
        func completePurchase(with error: Error, at index: Int = 0) {
            purchaseCompletions[index](.failure(error))
        }
        
        func completePurchaseSuccessfully(at index: Int = 0) {
            purchaseCompletions[index](.success(()))
        }
        
        // MARK: - Purchase Confirmation
        
        private(set) var confirmedRouteIds = [String]()
        
        var confirmationCallCount: Int {
            confirmedRouteIds.count
        }
        
        func confirmRoutePurchase(routeId: String, completion: ((RoutePurchaseConfirmationProvider.Result) -> Void)?) {
            confirmedRouteIds.append(routeId)
        }
        
        // MARK: - RoutesState
        
        private(set) var updatedRoutes = [Route]()
        
        func updateRoute(_ route: Route) {
            updatedRoutes.append(route)
        }
    }
    
}
