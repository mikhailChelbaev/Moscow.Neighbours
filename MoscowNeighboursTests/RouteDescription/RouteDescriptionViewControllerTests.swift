//
//  RouteDescriptionViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

struct RouteViewModel {}

final class RouteDescriptionViewController<RouteTransformer: ItemTransformer> {
    init(loader: RouteTransformer) {
        
    }
}

class RouteDescriptionViewControllerTests: XCTestCase {
    
    func test_init_doesNotTransformRoute() {
        let loader = LoaderSpy()
        let _ = RouteDescriptionViewController(loader: loader)
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transfromCallCount: Int = 0
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transfromCallCount += 1
        }
    }
    
}

