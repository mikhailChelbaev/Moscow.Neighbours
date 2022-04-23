//
//  RoutePurchaseWithConfirmationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 23.04.2022.
//

import XCTest
import MoscowNeighbours

class RoutePurchaseWithConfirmation: PurchaseOperationProvider {
    private let operation: PurchaseOperationProvider
    
    init(operation: PurchaseOperationProvider, confirmation: RoutePurchaseConfirmationProvider) {
        self.operation = operation
    }
    
    func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
        operation.purchaseProduct(product: product) { _ in }
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
    
    func test_purchaseProduct_executesOnlyOperation() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseProduct(product: route.purchase.product!) { _ in }
        
        XCTAssertEqual(loader.operationCallCount, 1)
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
    
    private func anyPaidRoute() -> Route {
        return makeRoute(price: (.buy, 200))
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
