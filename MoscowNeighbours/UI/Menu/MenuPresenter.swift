//
//  MenuPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol MenuEventHandler {
    var isUserAuthorized: Bool { get }
    var username: String? { get }
    var email: String? { get }
    var isUserVerified: Bool { get }
    
    func onBackButtonTap()
    func onAuthorizationButtonTap()
    func onSettingsCellTap()
    func onAccountCellTap()
    func onAchievementsCellTap()
    func onAccountConfirmationButtonTap()
    func onLogoutCellTap()
}

class MenuPresenter: MenuEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: MenuView?
    
    private let authorizationBuilder: AuthorizationBuilder
    private let settingsBuilder: SettingsBuilder
    private let profileBuilder: ProfileBuilder
    private let achievementsBuilder: AchievementsBuilder
    private let accountConfirmationBuilder: AccountConfirmationBuilder
    
    private let userState: UserState
    private let logoutManager: LogoutManager
    
    var isUserAuthorized: Bool {
        userState.isAuthorized
    }
    var username: String? {
        userState.currentUser?.name
    }
    var email: String? {
        userState.currentUser?.email
    }
    var isUserVerified: Bool {
        userState.currentUser?.isVerified ?? false
    }
    
    // MARK: - Init
    
    init(storage: MenuStorage) {
        authorizationBuilder = storage.authorizationBuilder
        settingsBuilder = storage.settingsBuilder
        profileBuilder = storage.profileBuilder
        achievementsBuilder = storage.achievementsBuilder
        accountConfirmationBuilder = storage.accountConfirmationBuilder
        
        userState = storage.userState
        logoutManager = storage.logoutManager
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
    
    func onAchievementsCellTap() {
        let controller = achievementsBuilder.buildAchievementsViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    func onAccountConfirmationButtonTap() {
        let controller = accountConfirmationBuilder.buildAccountConfirmationViewController(withChangeAccountButton: false,
                                                                                           completion: nil)
        viewController?.present(controller, state: .top, completion: nil)
    }
    
    func onLogoutCellTap() {
        let alertController = UIAlertController(title: "profile.exit_title".localized,
                                                message: "profile.exit_message".localized,
                                                preferredStyle: .alert)
        let yes = UIAlertAction(title: "common.yes".localized, style: .default, handler: { [weak self] _ in
            self?.logoutManager.logout()
            self?.viewController?.reloadData()
        })
        let no = UIAlertAction(title: "common.cancel".localized, style: .cancel)
        alertController.addAction(yes)
        alertController.addAction(no)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
}
