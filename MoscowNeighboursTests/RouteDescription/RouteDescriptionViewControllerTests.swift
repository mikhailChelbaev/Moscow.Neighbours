//
//  RouteDescriptionViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import XCTest
import MoscowNeighbours

class RouteDescriptionViewControllerTests: XCTestCase {
    
    func test_init_doesNotTransformRoute() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.transfromCallCount, 0)
    }
    
    func test_loadingIndicator_isVisibleWhileTransformingRoute() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesTransforming()
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once transforming completes successfully")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(route: Route = makeRoute(), file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: LoaderSpy) {
        let builder = Builder()
        let loader = LoaderSpy()
        let storage = RouteDescriptionStorage(model: route, routeTransformer: loader)
        let sut = builder.buildRouteDescriptionViewController(storage: storage)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
            
    private func makeUniqueRoute() {
        
    }
    
    private final class LoaderSpy: ItemTransformer {
        var transformationCompletions = [(RouteViewModel) -> Void]()
        
        var transfromCallCount: Int {
            return transformationCompletions.count
        }
        
        func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
            transformationCompletions.append(completion)
        }
        
        func completeRoutesTransforming(at index: Int = 0) {
            transformationCompletions[index](RouteViewModel())
        }
    }
    
}

private extension RouteDescriptionViewController {
    private var loader: LoadingCell? {
        let ds = tableView.dataSource
        
        guard ds!.tableView(tableView, numberOfRowsInSection: loaderIndexPath.section) > loaderIndexPath.row else {
            return nil
        }
        
        let cell = ds?.tableView(tableView, cellForRowAt: loaderIndexPath) as? TableCellWrapper<LoadingCell>
        return cell?.view
    }
    
    private var loaderIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    var isLoaderVisible: Bool {
        return loader != nil
    }
}
