//
//  RouteDescriptionViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

struct RouteViewModel {}

final class RouteDescriptionViewController<RouteTransformer: ItemTransformer> : UIViewController where RouteTransformer.Input == Route, RouteTransformer.Output == RouteViewModel {
    private var routeTransformer: RouteTransformer?
    
    convenience init(loader: RouteTransformer) {
        self.init()
        
        self.routeTransformer = loader
    }
    
    override func viewDidLoad() {
        routeTransformer?.transform(makeRoute(), completion: { _ in })
    }
}

class RouteDescriptionViewControllerTests: XCTestCase {
    
    func test_init_doesNotTransformRoute() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    func test_viewDidLoad_requestsRouteTransform() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.transfromCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController<LoaderSpy>, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = RouteDescriptionViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
            
    private func makeUniqueRoute() {
        
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transfromCallCount: Int = 0
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transfromCallCount += 1
        }
    }
    
}

