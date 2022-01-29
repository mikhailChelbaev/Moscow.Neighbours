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
    let achievementsBuilder: AchievementsBuilder
    let accountConfirmationBuilder: AccountConfirmationBuilder
    let userService: UserProvider
}

protocol MenuBuilder {
    func buildMenuViewController() -> MenuViewController
}

extension Builder: MenuBuilder {
    func buildMenuViewController() -> MenuViewController {
        let presenter = MenuPresenter(storage: buildStorage())
        let viewController = MenuViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage() -> MenuStorage {
        MenuStorage(authorizationBuilder: self,
                    settingsBuilder: self,
                    profileBuilder: self,
                    achievementsBuilder: self,
                    accountConfirmationBuilder: self,
                    userService: userService)
    }
}
