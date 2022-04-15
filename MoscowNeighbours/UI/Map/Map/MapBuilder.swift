//
//  MapBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

public struct MapStorage {
    let routesBuilder: () -> RouteViewController
    let personBuilder: PersonBuilder
    let menuBuilder: MenuBuilder
    
    let locationService: LocationService
    let mapService: MapService
    let routePassingService: RoutePassingService
}

protocol MapBuilder {
    func buildMapViewController() -> MapViewController
}

extension Builder: MapBuilder {
    func buildMapViewController() -> MapViewController {
        let presenter = MapPresenter(storage: makeMapStorage())
        let viewController = MapViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
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
    
    public static func mapComposeWith(_ storage: MapStorage) -> MapViewController {
        let presenter = MapPresenter(storage: storage)
        let viewController = MapViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}

public final class MapCoordinator {
    public var controller: MapViewController?
    
    public init(builder: Builder) {
        controller = MapUIComposer.mapComposeWith(builder.makeMapStorage())
    }
}
