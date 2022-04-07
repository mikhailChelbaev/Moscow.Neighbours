//
//  RouteViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 07.04.2022.
//

import XCTest
@testable import MoscowNeighbours

class RouteViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadRoutes() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_fetchesRoutes() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RouteViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let builder = Builder()
        let storage = RoutesStorage(
            routesService: loader,
            purchaseService: builder.purchaseService,
            userState: builder.userState,
            routesDescriptionBuilder: builder)
        let sut = builder.buildRouteViewController(with: storage)
        return (sut, loader)
    }
    
    private final class LoaderSpy: RoutesProvider {
        var observers: [String : RouteServiceDelegate] = [:]
        var loadCallCount: Int = 0
        
        func fetchRoutes() {
            loadCallCount += 1
        }
    }
    
    
}
