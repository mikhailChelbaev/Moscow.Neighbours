//
//  Builder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

class Builder {
    let api: ApiRequestsFactory
    
    let locationService: LocationService
    let routesService: RoutesProvider
    let mapService: MapService
    let routePassingService: RoutePassingService
    let jwtService: JWTService
    let userService: UserProvider
    let purchaseService: PurchaseProvider
    
    init() {
        api = ApiRequestsFactory.main
        
        locationService = .init()
        routesService = RoutesService(api: api)
        mapService = .init(routeFinder: NearestCoordinatesFinder(),
                           locationService: locationService)
        routePassingService = .init(locationService: locationService,
                                    notificationService: NotificationService())
        jwtService = JWTService.main
        userService = UserService.shared
        purchaseService = PurchaseService(userService: userService)
    }
}
