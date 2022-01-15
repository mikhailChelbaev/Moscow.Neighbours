//
//  MenuPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

protocol MenuEventHandler {
    var isUserAuthorized: Bool { get }
    var username: String? { get }
    var email: String? { get }
    
    func onBackButtonTap()
    func onAuthorizationButtonTap()
    func onSettingsCellTap()
    func onAccountCellTap()
}

class MenuPresenter: MenuEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: MenuView?
    
    private let authorizationBuilder: AuthorizationBuilder
    private let settingsBuilder: SettingsBuilder
    private let profileBuilder: ProfileBuilder
    
    private let userService: UserService
    
    var isUserAuthorized: Bool {
        userService.isAuthorized
    }
    var username: String? {
        userService.currentUser?.name
    }
    var email: String? {
        userService.currentUser?.email
    }
    
    // MARK: - Init
    
    init(storage: MenuStorage) {
        authorizationBuilder = storage.authorizationBuilder
        settingsBuilder = storage.settingsBuilder
        profileBuilder = storage.profileBuilder
        
        userService = storage.userService
    }
    
    // MARK: - MenuEventHandler
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onAuthorizationButtonTap() {
        let controller = authorizationBuilder.buildAuthorizationViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    func onAccountCellTap() {
        let controller = profileBuilder.buildProfileViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    func onSettingsCellTap() {
        let controller = settingsBuilder.buildSettingsViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
    
}
