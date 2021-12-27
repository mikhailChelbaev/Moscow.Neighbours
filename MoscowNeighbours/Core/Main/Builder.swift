//
//  Builder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

class Builder {
    let locationService: LocationService
    let mapService: MapService
    let routePassingService: RoutePassingService
    
    init() {
        locationService = .init()
        mapService = .init(routeFinder: NearestCoordinatesFinder(),
                           locationService: locationService)
        routePassingService = .init(locationService: locationService,
                                    notificationService: NotificationService())
    }
}
