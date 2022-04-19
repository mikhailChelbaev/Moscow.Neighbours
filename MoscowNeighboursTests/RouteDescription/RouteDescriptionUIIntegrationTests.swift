//
//  RouteDescriptionUIIntegrationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionUIIntegrationTests: XCTestCase {
    
    func test_bottomSheet_hasHeaderView() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.bottomSheet.headerView, sut.headerView)
    }
    
    func test_init_doesNotTransformRoute() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    func test_viewDidLoad_requestsRouteTransformation() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.transfromCallCount, 1)
    }
    
    func test_traitCollectionDidChange_requestsRouteTransformation() {
        let (sut, loader) = makeSUT()
        
        sut.traitCollectionDidChange(nil)
        
        XCTAssertEqual(loader.transfromCallCount, 1)
    }
    
    func test_loadingIndicator_isVisibleWhileTransformingRoute() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesTransforming(with: makeRouteModel())
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once transforming completes successfully")
    }
    
    func test_transformRouteCompletion_rendersTransformedRoute() {
        let route = makeRouteModel(from: makeRoute(personsInfo: [makePersonInfo(), makePersonInfo()]))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: route)
        
        assertThat(sut, isViewConfiguredFor: route)
    }
    
    func test_transformedRouteWithBuyStatus_rendersRouteDescriptionBuyButton() {
        let route = makeRouteModel(from: makeRoute(name: "Paid route", price: (.buy, "129$")))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: route)
        
        XCTAssertEqual(sut.headerCellButtonText, route.price, "Expected route header button text to be \(route.price)")
    }
    
    func test_transformedRouteWithPurchasedStatus_rendersStartRouteButton() {
        let route = makeRouteModel(from: makeRoute(name: "Purchased route", price: (.purchased, "129$")))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: route)
        
        XCTAssertEqual(sut.headerCellButtonText, localized("route_description.start_route"), "Expected route header button text to be \(localized("route_description.start_route"))")
    }
    
    func test_transformedRouteWithFreeStatus_rendersStartRouteButton() {
        let route = makeRouteModel(from: makeRoute(name: "Free route", price: (.free, nil)))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: route)
        
        XCTAssertEqual(sut.headerCellButtonText, localized("route_description.start_route"), "Expected route header button text to be \(localized("route_description.start_route"))")
    }
    
    func test_transformRouteCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completeRoutesTransforming(with: makeRouteModel())
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: RouteDescriptionLoaderSpy) {
        let loader = RouteDescriptionLoaderSpy()
        let storage = RouteDescriptionStorage(model: route, routeTransformer: loader)
        let sut = RoutesDescriptionUIComposer.routeDescriptionComposeWith(storage: storage, coordinator: RouteDescriptionCoordinator(route: route, builder: Builder()))
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}
