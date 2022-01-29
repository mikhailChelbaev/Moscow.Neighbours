//
//  SettingsBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import Foundation

struct SettingsStorage {
    let userService: UserProvider
    let mailService: EmailProvider
}

protocol SettingsBuilder {
    func buildSettingsViewController() -> SettingsViewController
}

extension Builder: SettingsBuilder {
    func buildSettingsViewController() -> SettingsViewController {
        let storage = SettingsStorage(userService: userService,
                                      mailService: EmailService())
        let presenter = SettingsPresenter(storage: storage)
        let viewController = SettingsViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
