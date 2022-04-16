//
//  MapCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.04.2022.
//

import Foundation

public final class MapCoordinator {
    public private(set) var controller: MapViewController?
    private let builder: Builder
    
    public init(builder: Builder) {
        self.builder = builder
    }
    
    public func start() {
        controller = MapUIComposer.mapComposeWith(builder.makeMapStorage(), coordinator: self)
    }
}
