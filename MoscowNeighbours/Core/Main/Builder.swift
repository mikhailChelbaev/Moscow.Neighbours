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
    let routesService: RoutesService
    public let mapService: MapService
    let routePassingService: RoutePassingService
    let jwtService: JWTService
    let userService: UserProvider
    let userState: UserState
    let logoutManager: LogoutManager
    let achievementsService: AchievementsService
    
    public init() {
        api = ApiRequestsFactory.main
        
        locationService = .init()
        mapService = .init(
            routeFinder: NearestCoordinatesFinder(),
            locationService: locationService)
        routePassingService = .init(
            locationService: locationService,
            notificationService: NotificationService())
        jwtService = JWTService.main
        userService = UserService()
        userState = UserState.shared
        achievementsService = AchievementsService(api: api)
        routesService = RoutesService(
            api: api,
            productsService: PurchaseProductsService())
        
        logoutManager = LogoutManager([
            userState,
            jwtService])
    }
}
