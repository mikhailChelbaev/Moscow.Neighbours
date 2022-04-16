//
//  MapBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation
import UIKit

public struct MapStorage {
    let routesBuilder: () -> RouteViewController
    let personBuilder: PersonBuilder
    let menuBuilder: MenuBuilder
    
    let locationService: LocationService
    let mapService: MapService
    let routePassingService: RoutePassingService
}

extension Builder {
    func makeMapStorage() -> MapStorage {
        return MapStorage(
            routesBuilder: { self.buildRouteViewController(with: self.makeRoutesStorage()) },
            personBuilder: self,
            menuBuilder: self,
            locationService: locationService,
            mapService: mapService,
            routePassingService: routePassingService)
    }
}

public final class MapUIComposer {
    private init() {}
    
    public static func mapComposeWith(_ storage: MapStorage, coordinator: MapCoordinator) -> MapViewController {
        let presenter = MapPresenter(storage: storage)
        let viewController = MapViewController(eventHandler: presenter, coordinator: coordinator)
        presenter.viewController = viewController
        return viewController
    }
}

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
