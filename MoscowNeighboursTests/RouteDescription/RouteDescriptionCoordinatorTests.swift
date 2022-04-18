//
//  RouteDescriptionCoordinatorTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 18.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionCoordinator {
    private let builder: Builder
    private let route: Route
    
    init(route: Route, builder: Builder) {
        self.builder = builder
        self.route = route
    }
    
    var controller: UIViewController?
    
    func start() {
        controller = builder.buildRouteDescriptionViewController(storage: RouteDescriptionStorage(
            model: route,
            routeTransformer: RouteTransformer()))
    }
}

class RouteDescriptionCoordinatorTests: XCTestCase {
    
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
    
    private func makeSUT(replaceControllerWith spy: PresentingControllerSpy? = nil, file: StaticString = #file, line: UInt = #line) -> RouteDescriptionCoordinator {
        let sut = RouteDescriptionCoordinator(route: makeRoute(), builder: Builder())
        if let spy = spy {
            sut.controller = spy
        }
        return sut
    }
    
}
