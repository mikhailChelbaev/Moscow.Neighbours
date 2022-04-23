//
//  RoutePurchaseWithConfirmationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 23.04.2022.
//

import XCTest
import MoscowNeighbours

class RoutePurchaseWithConfirmation: PurchaseOperationProvider {
    
    init(operation: PurchaseOperationProvider, confirmation: RoutePurchaseConfirmationProvider) {
        
    }
    
    func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
        
    }
    
    func restorePurchases(completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
        
    }
}

class RoutePurchaseWithConfirmationTests: XCTestCase {
    
    func test_init_doesNotPurchase() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.operationCallCount, 0)
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PurchaseOperationProvider, loader: PurchaseSpy) {
        let loader = PurchaseSpy()
        let sut = RoutePurchaseWithConfirmation(operation: loader, confirmation: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private final class PurchaseSpy: PurchaseOperationProvider, RoutePurchaseConfirmationProvider {
        
        // MARK: - Purchase Operation
        private(set) var operationCallCount: Int = 0
        
        func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
            operationCallCount += 1
        }
        
        func restorePurchases(completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
            
        }
        
        // MARK: - Purchase Confirmation
        private(set) var confirmationCallCount: Int = 0
        
        func confirmRoutePurchase(routeId: String) async throws {
            confirmationCallCount += 1
        }
    }
    
}
