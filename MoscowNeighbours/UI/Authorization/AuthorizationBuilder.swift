//
//  AuthorizationBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

struct AuthorizationStorage {
    
}

protocol AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController
}

extension Builder: AuthorizationBuilder {
    func buildAuthorizationViewController() -> AuthorizationViewController {
        let storage = AuthorizationStorage()
        let presenter = AuthorizationPresenter(storage: storage)
        let viewController = AuthorizationViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
