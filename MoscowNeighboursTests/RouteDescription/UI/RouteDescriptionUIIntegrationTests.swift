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
        
        loader.completeRouteTransformingSuccessfully()
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once transforming completes successfully")
    }
    
    func test_transformRouteCompletion_rendersTransformedRoute() {
        let route = makeRoute(personsInfo: [makePersonInfo(), makePersonInfo()])
        let text = NSAttributedString(string: route.description)
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRoutesTransforming(with: text)
        
        assertThat(sut, isViewConfiguredFor: route, text: text)
    }
    
    func test_transformedRouteWithBuyStatus_rendersRouteDescriptionBuyButton() {
        let route = makeRoute(name: "Paid route", price: (.buy, 129))
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        XCTAssertEqual(sut.headerCellButtonText, route.localizedPrice(), "Expected route header button text to be \(route.localizedPrice())")
    }
    
    func test_transformedRouteWithPurchasedStatus_rendersStartRouteButton() {
        let route = makeRoute(name: "Purchased route", price: (.purchased, 129))
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        XCTAssertEqual(sut.headerCellButtonText, localized("route_description.start_route"), "Expected route header button text to be \(localized("route_description.start_route"))")
    }
    
    func test_transformedRouteWithFreeStatus_rendersStartRouteButton() {
        let route = makeRoute(name: "Free route", price: (.free, nil))
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        XCTAssertEqual(sut.headerCellButtonText, localized("route_description.start_route"), "Expected route header button text to be \(localized("route_description.start_route"))")
    }
    
    func test_headerButton_displaysLoaderAndDisableWhilePurchasingRoute() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        
        XCTAssertEqual(sut.isHeaderButtonLoaderVisible, false)
        XCTAssertEqual(sut.isHeaderButtonEnabled, true)
        
        sut.simulateHeaderButtonTap()
        XCTAssertEqual(sut.isHeaderButtonLoaderVisible, true)
        XCTAssertEqual(sut.isHeaderButtonEnabled, false)
        
        loader.completePurchaseSuccessfully()
        XCTAssertEqual(sut.isHeaderButtonLoaderVisible, false)
        XCTAssertEqual(sut.isHeaderButtonEnabled, true)
    }
    
    func test_purchaseButton_changesTextAfterSuccessfulPurchase() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT(route: route)
        
        sut.loadViewIfNeeded()
        loader.completeRouteTransformingSuccessfully()
        sut.simulateHeaderButtonTap()
        loader.completePurchaseSuccessfully()
        
        XCTAssertEqual(sut.headerCellButtonText, localized("route_description.start_route"), "Expected route header button text to be \(localized("route_description.start_route")), got \(String(describing: sut.headerCellButtonText)) instead")
    }
    
    func test_transformRouteCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completeRouteTransformingSuccessfully()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_routePurchaseCompletion_dispatchesFromBackgroundToMainThread() {
        let route = anyPaidRoute()
        let (sut, loader) = makeSUT(route: route)
        sut.loadViewIfNeeded()
        
        loader.completeRouteTransformingSuccessfully()
        sut.simulateHeaderButtonTap()

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completePurchaseSuccessfully()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: RouteDescriptionLoaderSpy) {
        let builder = Builder()
        let loader = RouteDescriptionLoaderSpy()
        let storage = RouteDescriptionStorage(model: route, markdownTransformer: loader, mapService: builder.mapService, purchaseService: loader)
        let sut = RoutesDescriptionUIComposer.routeDescriptionComposeWith(storage: storage, coordinator: RouteDescriptionCoordinator(route: route, builder: builder), mapService: builder.mapService)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func anyPaidRoute() -> Route {
        return makeRoute(name: "Paid route", price: (.buy, 129))
    }
}
