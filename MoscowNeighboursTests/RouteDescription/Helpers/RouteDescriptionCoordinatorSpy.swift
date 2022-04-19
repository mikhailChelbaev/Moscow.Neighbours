//
//  RouteDescriptionCoordinatorSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

@testable import MoscowNeighbours

class RouteDescriptionCoordinatorSpy: RouteDescriptionCoordinator {
    enum Message {
        case dismiss
    }
    
    private(set) var receivedMessages = [Message]()
    
    override func dismiss(animated: Bool, completion: Action? = nil) {
        receivedMessages.append(.dismiss)
    }
}
