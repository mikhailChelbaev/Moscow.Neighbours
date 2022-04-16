//
//  RouteCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 16.04.2022.
//

import XCTest
import MoscowNeighbours

class RoutesCoordinator {
    private(set) var controller: RouteViewController?
    private let builder: Builder

    init(builder: Builder) {
        self.builder = builder
    }
}

class RouteCoordinatorTests: XCTestCase {
    
    func test_init_doesNotCreateController() {
        let coordinator = makeSUT()
        
        XCTAssertNil(coordinator.controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RoutesCoordinator {
        let sut = RoutesCoordinator(builder: Builder())
        return sut
    }
}
