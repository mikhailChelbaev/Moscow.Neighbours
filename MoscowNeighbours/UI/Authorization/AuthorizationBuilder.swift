//
//  AuthorizationBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

struct AuthorizationStorage {
    let authorizationService: AuthorizationService
    let jwtService: JWTService
    let userService: UserService
}

protocol AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController
}

extension Builder: AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController {
        let storage = AuthorizationStorage(authorizationService: AuthorizationService(api: requestsFactory),
                                           jwtService: jwtService,
                                           userService: userService)
        let presenter = AuthorizationPresenter(storage: storage)
        let viewController = AuthorizationViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
