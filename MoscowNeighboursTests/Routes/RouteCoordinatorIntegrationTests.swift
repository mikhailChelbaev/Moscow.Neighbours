//
//  RouteCoordinatorIntegrationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 18.04.2022.
//

import XCTest
@testable import MoscowNeighbours

class RouteCoordinatorIntegrationTests: XCTestCase {
    
    func test_routeCellTap_presentsRouteDescriptionController() {
        let route = makeRoute()
        let (sut, loader, coordinator) = makeSUT()

        sut.loadViewIfNeeded()
        coordinator.start()
        loader.completeRoutesLoading(with: [route])
        sut.simulateCellTap(at: 0)

        XCTAssertEqual(coordinator.presentedRoute?.id, route.id)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RoutesViewController, loader: RoutesLoaderSpy, coordinator: RoutesCoordinatorStub) {
        let builder = Builder()
        let loader = RoutesLoaderSpy()
        let storage = RoutesStorage(
            routesService: loader,
            routesDescriptionBuilder: builder,
            routesFetchDelayManager: TestDelayManager(),
            userState: builder.userState)
        let coordinator = RoutesCoordinatorStub(storage: storage)
        let sut = RoutesUIComposer.routesComposeWith(storage, coordinator: coordinator)
        return (sut, loader, coordinator)
    }
}
