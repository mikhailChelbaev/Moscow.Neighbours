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
    let purchaseService: PurchaseProvider
    let routesService: RoutesProvider
    let mapService: MapService
    let routePassingService: RoutePassingService
    let jwtService: JWTService
    let userService: UserProvider
    
    init() {
        api = ApiRequestsFactory.main
        
        locationService = .init()
        mapService = .init(routeFinder: NearestCoordinatesFinder(),
                           locationService: locationService)
        routePassingService = .init(locationService: locationService,
                                    notificationService: NotificationService())
        jwtService = JWTService.main
        userService = UserService.shared
        purchaseService = PurchaseService(userService: userService)
        routesService = RoutesService(api: api, purchaseService: purchaseService)
    }
}
