//
//  MapCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 15.04.2022.
//

import XCTest
import MoscowNeighbours

class MapCoordinatorTests: XCTestCase {
    
    func test_init_doesNotCreateController() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.controller)
    }
    
    func test_start_createsController() {
        let sut = makeSUT()
        
        sut.start()
        
        XCTAssertNotNil(sut.controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MapCoordinator {
        let sut = MapCoordinator(builder: Builder())
        return sut
    }
    
}
