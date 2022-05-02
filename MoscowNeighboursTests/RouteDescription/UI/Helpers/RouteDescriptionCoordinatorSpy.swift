//
//  RouteDescriptionCoordinatorSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

@testable import MoscowNeighbours

class RouteDescriptionCoordinatorSpy: RouteDescriptionCoordinator {
    enum Message: Equatable {
        case dismiss
        case displayPerson
        case startRoutePassing
        case displayAlert(title: String?, subtitle: String?, actions: [AlertAction])
    }
    
    private(set) var receivedMessages = [Message]()
    
    override func dismiss(animated: Bool, completion: Action? = nil) {
        receivedMessages.append(.dismiss)
    }
    
    override func displayPerson(_ personInfo: PersonInfo) {
        receivedMessages.append(.displayPerson)
    }
    
    override func startPassingRoute() {
        receivedMessages.append(.startRoutePassing)
    }
    
    override func displayAlert(title: String?, subtitle: String?, actions: [AlertAction]) {
        receivedMessages.append(.displayAlert(title: title, subtitle: subtitle, actions: actions))
    }
}
