//
//  MapCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 15.04.2022.
//

import XCTest
import MoscowNeighbours

class MapCoordinatorTests: XCTestCase {
    
    func test_init_createsMapViewController() {
        let coordinator = makeSUT()
        
        XCTAssertNotNil(coordinator.controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MapCoordinator {
        let sut = MapCoordinator(builder: Builder())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
}
