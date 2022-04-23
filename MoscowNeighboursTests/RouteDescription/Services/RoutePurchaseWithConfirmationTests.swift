//
//  RoutePurchaseWithConfirmationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 23.04.2022.
//

import XCTest
import MoscowNeighbours

class RoutePurchaseWithConfirmationTests: XCTestCase {
    
    func test_init_doesNotPurchase() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.operationCallCount, 0)
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProduct_executesOnlyOperation() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: route) { _ in }
        
        XCTAssertEqual(loader.operationCallCount, 1)
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProductCompletion_doesNotCallConfirmationIfFailed() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: route) { _ in }
        loader.completePurchase(with: anyNSError())
        
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProductCompletion_callsConfirmationIfSucceeded() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: route) { _ in }
        loader.completePurchaseSuccessfully()
        
        XCTAssertEqual(loader.confirmationCallCount, 1)
    }
    
    func test_purchaseConfirmation_usesCorrectRouteId() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: route) { _ in }
        loader.completePurchaseSuccessfully()
        
        XCTAssertEqual(loader.confirmedRouteIds, [route.id])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PurchaseWithConfirmationProvider, loader: PurchaseSpy) {
        let loader = PurchaseSpy()
        let sut = RoutePurchaseWithConfirmationService(operation: loader, confirmation: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }   
}
