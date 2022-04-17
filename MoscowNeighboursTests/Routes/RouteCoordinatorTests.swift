//
//  RouteCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 16.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteCoordinatorTests: XCTestCase {
    
    func test_init_doesNotCreateController() {
        let coordinator = makeSUT()
        
        XCTAssertNil(coordinator.controller)
    }
    
    func test_start_createsController() {
        let coordinator = makeSUT()
        
        coordinator.start()
        
        XCTAssertNotNil(coordinator.controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RoutesCoordinator {
        let sut = RoutesCoordinator(builder: Builder())
        return sut
    }
}
