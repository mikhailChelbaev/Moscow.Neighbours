//
//  MapCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.04.2022.
//

import UIKit

public final class MapCoordinator {
    public var controller: UIViewController?
    private let builder: Builder
    
    public init(builder: Builder) {
        self.builder = builder
    }
    
    public func start() {
        controller = MapUIComposer.mapComposeWith(builder.makeMapStorage(), coordinator: self)
    }
    
    public func displayRoutes() {
        let coordinator = RoutesCoordinator(builder: builder)
        coordinator.start()
        coordinator.present(on: controller, state: .middle, animated: true, completion: nil)
    }
}
