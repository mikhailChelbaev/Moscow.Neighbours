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
    
    func test_fetchRoutesCompletion_rendersSuccessfullyLoadedRoutes() {
        let route0 = makeRoute(name: "Route 1", price: (.free, nil))
        let route1 = makeRoute(name: "Route 2", price: (.purchased, nil))
        let route2 = makeRoute(name: "Route 3", price: (.buy, "100"))
        let route3 = makeRoute(name: "Route 4", price: (.buy, "200"))
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeRoutesLoading(with: [route0, route1, route2, route3], at: 0)
        
        assertThat(sut, isRendering: [route0, route1, route2, route3])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let builder = Builder()
        let storage = RoutesStorage(
            routesService: loader,
            routesDescriptionBuilder: builder,
            routesFetchDelayManager: TestDelayManager())
        let sut = builder.buildRouteViewController(with: storage)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeRoute(name: String, price: (status: Purchase.Status, value: String?)) -> Route {
        return Route(id: UUID().uuidString, name: "some name", description: "description", coverUrl: nil, duration: "200 min", distance: "200 km", personsInfo: [], purchase: .init(status: price.status, productId: nil), price: price.value)
    }
    
    func assertThat(_ sut: RouteViewController, isRendering routes: [Route], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedRouteViews() == routes.count else {
            return XCTFail("Expected \(routes.count) routes, got \(sut.numberOfRenderedRouteViews()) instead", file: file, line: line)
        }
        
        routes.enumerated().forEach { index, route in
            assertThat(sut, hasViewConfiguredFor: route, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: RouteViewController, hasViewConfiguredFor route: Route, at index: Int, file: StaticString = #file, line: UInt = #line) {
        guard let cell = sut.routeView(at: index) else {
            return XCTFail("Expected to get cell at index \(index)")
        }
        
        XCTAssertEqual(cell.titleText, route.name, "Expected title text to be \(String(describing: route.name)) for route cell at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.buttonText, route.localizedPrice(), "Expected button text to be \(String(describing: route.localizedPrice())) for route cell at index (\(index))", file: file, line: line)
    }
    
    private final class LoaderSpy: RoutesProvider {
        var completions = [(RoutesProvider.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func fetchRoutes(completion: @escaping (RoutesProvider.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeRoutesLoading(with routes: [Route] = [], at index: Int = 0) {
            completions[index](.success(routes))
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
    
    func numberOfRenderedRouteViews() -> Int {
        return tableView.numberOfRows(inSection: routesSection)
    }
    
    func routeView(at row: Int) -> RouteCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: routesSection)
        let cell = ds?.tableView(tableView, cellForRowAt: index) as? TableCellWrapper<RouteCell>
        return cell?.view
    }
 
    private var routesSection: Int {
        return 0
    }
}

extension RouteCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var buttonText: String? {
        return buyButton.titleLabel?.text
    }
}

final class TestDelayManager: DelayManager {
    func start() {}
    
    func completeWithDelay(_ completion: Action?) {
        completion?()
    }
}
