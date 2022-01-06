//
//  SettingsBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import Foundation

struct SettingsStorage {
    let userService: UserService
}

protocol SettingsBuilder {
    func buildSettingsViewController() -> SettingsViewController
}

extension Builder: SettingsBuilder {
    func buildSettingsViewController() -> SettingsViewController {
        let storage = SettingsStorage(userService: userService)
        let presenter = SettingsPresenter(storage: storage)
        let viewController = SettingsViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
