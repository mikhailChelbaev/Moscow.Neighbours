//
//  PurchaseRouteCompositionServiceTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 23.04.2022.
//

import XCTest
import MoscowNeighbours

class PurchaseRouteCompositionServiceTests: XCTestCase {
    
    func test_init_doesNotPurchase() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.operationCallCount, 0)
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProduct_executesOnlyOperation() {
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: anyPaidRoute()) { _ in }
        
        XCTAssertEqual(loader.operationCallCount, 1)
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProductCompletion_doesNotCallConfirmationIfFailed() {
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: anyPaidRoute()) { _ in }
        loader.completePurchase(with: anyNSError())
        
        XCTAssertEqual(loader.confirmationCallCount, 0)
    }
    
    func test_purchaseProductCompletion_callsConfirmationIfSucceeded() {
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: anyPaidRoute()) { _ in }
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
    
    func test_purchaseRoute_completesWithPurchaseProductResult() {
        let (sut, loader) = makeSUT()
        let error = anyNSError()
        
        expect(sut, toCompleteWith: .success(()), when: {
            loader.completePurchaseSuccessfully(at: 0)
        })
        
        expect(sut, toCompleteWith: .failure(error), when: {
            loader.completePurchase(with: error, at: 1)
        })
    }
    
    func test_purchaseRoute_updatesRoutesStateIfPurchaseSucceeded() {
        var route = anyPaidRoute()
        let (sut, loader) = makeSUT()
        
        sut.purchaseRoute(route: route) { _ in }
        loader.completePurchaseSuccessfully()
        
        route.purchase.status = .purchased
        XCTAssertEqual(loader.updatedRoutes, [route])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PurchaseRouteProvider, loader: PurchaseSpy) {
        let loader = PurchaseSpy()
        let sut = PurchaseRouteCompositionService(operation: loader, confirmation: loader, routesState: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

}
