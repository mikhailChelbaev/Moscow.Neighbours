//
//  RoutesCoordinatorStub.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 17.04.2022.
//

@testable import MoscowNeighbours

class RoutesCoordinatorStub: RoutesCoordinator {
    private(set) var presentedRoute: Route?
    private let storage: RoutesStorage
    
    init(storage: RoutesStorage) {
        self.storage = storage
        super.init(builder: Builder())
    }
    
    override func start() {
        controller = RoutesUIComposer.routesComposeWith(storage, coordinator: self)
    }
    
    override func displayRoute(route: Route) {
        presentedRoute = route
    }
}
