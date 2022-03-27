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
    let userState: UserState
    let userService: UserProvider
    let accountConfirmationBuilder: AccountConfirmationBuilder
}

protocol AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController
}

extension Builder: AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController {
        let storage = AuthorizationStorage(authorizationService: AuthorizationService(api: api),
                                           jwtService: jwtService,
                                           userState: userState,
                                           userService: userService,
                                           accountConfirmationBuilder: self)
        let presenter = AuthorizationPresenter(storage: storage)
        let viewController = AuthorizationViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
