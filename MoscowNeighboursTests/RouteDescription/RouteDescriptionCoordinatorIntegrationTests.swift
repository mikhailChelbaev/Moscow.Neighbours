//
//  RouteDescriptionCoordinatorIntegrationTests.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import XCTest
@testable import MoscowNeighbours

class RouteDescriptionCoordinatorIntegrationTests: XCTestCase {
    
    func test_closeButton_dismissesController() {
        let (sut, _, coordinator) = makeSUT()
        
        sut.simulateBackButtonTap()
        
        XCTAssertEqual(coordinator.receivedMessages, [.dismiss])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RouteDescriptionViewController, loader: RouteDescriptionLoaderSpy, coordinator: RouteDescriptionCoordinatorSpy) {
        let route = makeRoute()
        let loader = RouteDescriptionLoaderSpy()
        let coordinator = RouteDescriptionCoordinatorSpy(route: route, builder: Builder())
        let storage = RouteDescriptionStorage(model: route, routeTransformer: loader)
        let sut = RoutesDescriptionUIComposer.routeDescriptionComposeWith(storage: storage, coordinator: coordinator)
        return (sut, loader, coordinator)
    }
    
    private class RouteDescriptionCoordinatorSpy: RouteDescriptionCoordinator {
        enum Message {
            case dismiss
        }
        
        private(set) var receivedMessages = [Message]()
        
        override func dismiss(animated: Bool, completion: Action? = nil) {
            receivedMessages.append(.dismiss)
        }
    }
    
}

extension RouteDescriptionViewController {
    func simulateBackButtonTap() {
        backButton.simulateTap()
    }
}

extension UIButton {
    @objc func simulateTap() {
        sendActions(for: .touchUpInside)
    }
}
