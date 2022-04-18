//
//  RouteUIIntegrationTests+Assertions.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import XCTest
@testable import MoscowNeighbours

extension RouteUIIntegrationTests {
    func assertThat(_ sut: RoutesViewController, isRendering routes: [Route], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedRouteViews() == routes.count else {
            return XCTFail("Expected \(routes.count) routes, got \(sut.numberOfRenderedRouteViews()) instead", file: file, line: line)
        }
        
        routes.enumerated().forEach { index, route in
            assertThat(sut, hasViewConfiguredFor: route, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: RoutesViewController, hasViewConfiguredFor route: Route, at index: Int, file: StaticString = #file, line: UInt = #line) {
        guard let cell = sut.routeView(at: index) else {
            return XCTFail("Expected to get cell at index \(index)")
        }
        
        XCTAssertEqual(cell.titleText, route.name, "Expected title text to be \(String(describing: route.name)) for route cell at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.buttonText, route.localizedPrice(), "Expected button text to be \(String(describing: route.localizedPrice())) for route cell at index (\(index))", file: file, line: line)
    }
}
