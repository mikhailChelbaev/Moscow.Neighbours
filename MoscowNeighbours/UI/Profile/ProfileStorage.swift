//
//  ProfileStorage.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.01.2022.
//

import Foundation

struct ProfileStorage {
    let userState: UserState
    let logoutManager: LogoutManager
}

protocol ProfileBuilder {
    func buildProfileViewController() -> ProfileViewController
}

extension Builder: ProfileBuilder {
    func buildProfileViewController() -> ProfileViewController {
        let storage = ProfileStorage(userState: userState,
                                     logoutManager: logoutManager)
        let presenter = ProfilePresenter(storage: storage)
        let viewController = ProfileViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
