//
//  AccountConfirmationBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import Foundation

struct AccountConfirmationStorage {
    let accountConfirmationService: AccountConfirmationProvider
    let userService: UserProvider
    let jwtService: JWTService
    let userState: UserState
    let logoutManager: LogoutManager
    let successfulConfirmationCompletion: Action?
}

protocol AccountConfirmationBuilder {
    func buildAccountConfirmationViewController(withChangeAccountButton: Bool, completion: Action?) -> AccountConfirmationViewController
}

extension Builder: AccountConfirmationBuilder {
    func buildAccountConfirmationViewController(withChangeAccountButton: Bool, completion: Action?) -> AccountConfirmationViewController {
        let presenter = AccountConfirmationPresenter(storage: buildStorage(completion: completion))
        let viewController = AccountConfirmationViewController(eventHandler: presenter,
                                                               withChangeAccountButton: withChangeAccountButton)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage(completion: Action?) -> AccountConfirmationStorage {
        return AccountConfirmationStorage(accountConfirmationService: AccountConfirmationService(api: api),
                                          userService: userService,
                                          jwtService: jwtService,
                                          userState: userState,
                                          logoutManager: logoutManager,
                                          successfulConfirmationCompletion: completion)
    }
}
