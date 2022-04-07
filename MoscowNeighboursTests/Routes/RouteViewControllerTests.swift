//
//  RouteViewControllerTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 07.04.2022.
//

import XCTest
@testable import MoscowNeighbours

class RouteViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadRoutes() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_fetchesRoutes() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_loadingIndicator_isVisibleWhileFetchingRoutes() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isLoaderVisible, "Expected loading indicator once view is loaded")
        
        loader.completeRoutesLoading()
        XCTAssertFalse(sut.isLoaderVisible, "Expected no loading indicator once loading completes successfully")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let builder = Builder()
        let storage = RoutesStorage(
            routesService: loader,
            userState: builder.userState,
            routesDescriptionBuilder: builder,
            routesFetchDelayManager: TestDelayManager())
        let sut = builder.buildRouteViewController(with: storage)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private final class LoaderSpy: RoutesProvider {
        var completions = [(RoutesProvider.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func fetchRoutes(completion: @escaping (RoutesProvider.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeRoutesLoading(at index: Int = 0) {
            completions[index](.success([]))
        }
    }
}

extension RouteViewController {
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

final class TestDelayManager: DelayManager {
    func start() {}
    
    func completeWithDelay(_ completion: Action?) {
        completion?()
    }
}
