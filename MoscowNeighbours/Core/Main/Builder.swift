//
//  Builder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

public class Builder {
    let api: ApiRequestsFactory
    
    let locationService: LocationService
    let purchaseService: PurchaseProvider
    let routesService: RoutesService
    public let mapService: MapService
    let routePassingService: RoutePassingService
    let jwtService: JWTService
    let userService: UserProvider
    let userState: UserState
    let logoutManager: LogoutManager
    
    public init() {
        api = ApiRequestsFactory.main
        
        locationService = .init()
        mapService = .init(routeFinder: NearestCoordinatesFinder(),
                           locationService: locationService)
        routePassingService = .init(locationService: locationService,
                                    notificationService: NotificationService())
        jwtService = JWTService.main
        userService = UserService()
        userState = UserState.shared
        purchaseService = PurchaseService(userState: userState)
        routesService = RoutesService(api: api, purchaseService: purchaseService)
        
        logoutManager = LogoutManager([
            userState,
            jwtService
        ])
    }
}
