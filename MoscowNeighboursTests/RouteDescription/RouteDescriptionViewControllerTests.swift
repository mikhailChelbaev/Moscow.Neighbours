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
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController<LoaderSpy>, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = RouteDescriptionViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transfromCallCount: Int = 0
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transfromCallCount += 1
        }
    }
    
}

