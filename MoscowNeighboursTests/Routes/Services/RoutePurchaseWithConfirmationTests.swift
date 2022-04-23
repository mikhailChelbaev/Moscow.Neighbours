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
    private let confirmation: RoutePurchaseConfirmationProvider
    
    init(operation: PurchaseOperationProvider, confirmation: RoutePurchaseConfirmationProvider) {
        self.operation = operation
        self.confirmation = confirmation
    }
    
    func purchaseProduct(product: Product, completion: @escaping (PurchaseOperationProvider.Result) -> Void) {
        operation.purchaseProduct(product: product) { [weak self] result in
            if case Result.success = result {
                self?.confirmation.confirmRoutePurchase(routeId: "", completion: nil)
            }
        }
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
    
    func test_purchaseProductCompletion_doesNotCallConfirmationIfFailed() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseProduct(product: route.purchase.product!) { _ in }
        loader.completePurchase(with: anyNSError())
        
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProductCompletion_callsConfirmationIfSucceeded() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseProduct(product: route.purchase.product!) { _ in }
        loader.completePurchaseSuccessfully()
        
        XCTAssertEqual(loader.confirmationCallCount, 1)
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
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private final class PurchaseSpy: PurchaseOperationProvider, RoutePurchaseConfirmationProvider {
        
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
            purchaseCompletions[index](.success(true))
        }
        
        // MARK: - Purchase Confirmation
        private(set) var confirmationCallCount: Int = 0
        
        func confirmRoutePurchase(routeId: String, completion: ((RoutePurchaseConfirmationProvider.Result) -> Void)?) {
            confirmationCallCount += 1
        }
    }
    
}
