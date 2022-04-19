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
    
    func assertThat(_ sut: RouteDescriptionViewController, isViewConfiguredFor route: RouteViewModel, file: StaticString = #file, line: UInt = #line) {
        guard sut.currentNumberOfSections == sut.numberOfSections else {
            return XCTFail("Expected to display \(sut.numberOfSections) sections, got \(sut.currentNumberOfSections) instead")
        }
        
        XCTAssertEqual(sut.headerCellTitle, route.name, "Expected title text to be \(route.name)", file: file, line: line)
        XCTAssertEqual(sut.headerCellInfoText, route.routeInformation, "Expected route information text to be \(route.routeInformation)", file: file, line: line)
        
        XCTAssertEqual(sut.informationHeaderText, localized("route_description.information"), "Expected information header text to be \(localized("route_description.information"))", file: file, line: line)
        XCTAssertEqual(sut.informationCellText, route.description.string, "Expected information text to be \(route.description.string)", file: file, line: line)
        XCTAssertTrue(sut.isInformationSeparatorVisible, "Expected information separator to be visible", file: file, line: line)

        XCTAssertEqual(sut.personsHeaderText, localized("route_description.places"), "Expected persons header text to be \(localized("route_description.places"))", file: file, line: line)
        assertThat(sut, isRendering: route.persons, file: file, line: line)
    }
    
    func assertThat(_ sut: RouteDescriptionViewController, isRendering personInfos: [PersonInfo], file: StaticString = #file, line: UInt = #line) {
        personInfos.enumerated().forEach { index, personInfo in
            assertThat(sut, hasViewConfiguredFor: personInfo, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: RouteDescriptionViewController, hasViewConfiguredFor personInfo: PersonInfo, at index: Int, file: StaticString = #file, line: UInt = #line) {
        guard let cell = sut.personCell(at: index) else {
            return XCTFail("Expected to get cell at index \(index)", file: file, line: line)
        }

        XCTAssertEqual(cell.personNameText, personInfo.person.name, "Expected person name text to be \(personInfo.person.name) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.addressText, personInfo.place.address, "Expected address text to be \(personInfo.place.address) for route cell at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.houseTitleText, personInfo.place.name, "Expected house title text to be \(personInfo.place.name) for route cell at index (\(index))", file: file, line: line)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Localizable"
        let bundle = Bundle(for: RouteDescriptionViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }    
}
