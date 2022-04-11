//
//  RouteViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 07.04.2022.
//

import XCTest
@testable import MoscowNeighbours

class RouteViewControllerTests: XCTestCase {
    
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
    
    func test_errorViewRetryButton_retriesRoutesLoad() {
        let route = makeRoute(name: "Route 1", price: (.free, nil))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesLoading(with: NSError(), at: 0)
        
        sut.simulateErrorViewButtonTap()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator after retry button tap")
        
        loader.completeRoutesLoading(with: [route], at: 1)
        assertThat(sut, isRendering: [route])
    }
    
    func test_routesList_reloadsAfterUserStateChange() {
        let userState = UserState(storeContainer: FakeStoreContainer())
        let (sut, loader) = makeSUT(userState: userState)
        
        sut.loadViewIfNeeded()
        loader.completeRoutesLoading()
        userState.currentUser = nil
        
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator after current user change")
    }
    
    func test_fetchRoutesCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completeRoutesLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(userState: UserState = UserState(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let builder = Builder()
        let storage = RoutesStorage(
            routesService: loader,
            routesDescriptionBuilder: builder,
            routesFetchDelayManager: TestDelayManager(),
            userState: userState)
        let sut = builder.buildRouteViewController(with: storage)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeRoute(name: String = "Route", price: (status: Purchase.Status, value: String?) = (.free, nil)) -> Route {
        return Route(id: UUID().uuidString, name: "some name", description: "description", coverUrl: nil, duration: "200 min", distance: "200 km", personsInfo: [], purchase: .init(status: price.status, productId: nil), price: price.value)
    }
}
