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
    
    func test_displayRoutes_presentsRoutesController() {
        let presentationSpy = PresentingControllerSpy()
        let sut = makeSUT(replaceControllerWith: presentationSpy)
        
        sut.displayRoutes()
        
        XCTAssertEqual(presentationSpy.presentedController is RoutesViewController, true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(replaceControllerWith spy: PresentingControllerSpy? = nil, file: StaticString = #file, line: UInt = #line) -> MapCoordinator {
        let sut = MapCoordinator(builder: Builder())
        if let spy = spy {
            sut.controller = spy
        }
        return sut
    }
    
}
