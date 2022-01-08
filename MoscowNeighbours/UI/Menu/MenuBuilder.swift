//
//  MenuBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

struct MenuStorage {
    let authorizationBuilder: AuthorizationBuilder
    let settingsBuilder: SettingsBuilder
    let profileBuilder: ProfileBuilder
    let userService: UserService
}

protocol MenuBuilder {
    func buildMenuViewController() -> MenuViewController
}

extension Builder: MenuBuilder {
    func buildMenuViewController() -> MenuViewController {
        let storage = MenuStorage(authorizationBuilder: self,
                                  settingsBuilder: self,
                                  profileBuilder: self,
                                  userService: userService)
        let presenter = MenuPresenter(storage: storage)
        let viewController = MenuViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
