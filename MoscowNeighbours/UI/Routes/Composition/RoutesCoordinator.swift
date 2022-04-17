//
//  RoutesCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 17.04.2022.
//

import Foundation

public class RoutesCoordinator {
    public private(set) var controller: RouteViewController?
    private let builder: Builder

    public init(builder: Builder) {
        self.builder = builder
    }
    
    public func start() {
        let storage = builder.makeRoutesStorage()
        controller = RoutesUIComposer.routesComposeWith(storage, coordinator: self)
    }
}
