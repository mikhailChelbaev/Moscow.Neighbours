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
    
    func test_loadingIndicator_isVisibleWhileFetchingRoutes() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesLoading()
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once loading completes successfully")
    }
    
    func test_fetchRoutesCompletion_rendersSuccessfullyLoadedRoutes() {
        let route0 = makeRoute(name: "Route 1", price: (.free, nil))
        let route1 = makeRoute(name: "Route 2", price: (.purchased, nil))
        let route2 = makeRoute(name: "Route 3", price: (.buy, "100"))
        let route3 = makeRoute(name: "Route 4", price: (.buy, "200"))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesLoading(with: [route0, route1, route2, route3], at: 0)
        
        assertThat(sut, isRendering: [route0, route1, route2, route3])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let builder = Builder()
        let storage = RoutesStorage(
            routesService: loader,
            routesDescriptionBuilder: builder,
            routesFetchDelayManager: TestDelayManager())
        let sut = builder.buildRouteViewController(with: storage)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeRoute(name: String, price: (status: Purchase.Status, value: String?)) -> Route {
        return Route(id: UUID().uuidString, name: "some name", description: "description", coverUrl: nil, duration: "200 min", distance: "200 km", personsInfo: [], purchase: .init(status: price.status, productId: nil), price: price.value)
    }
}
