//
//  SettingsPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import UIKit

protocol SettingsEventHandler {
    var isUserAuthorized: Bool { get }
    var isPushNotificationsEnabled: Bool { get }
    var isEmailNotificationsEnabled: Bool { get }
    
    func onBackButtonTap()
    func onLanguageButtonTap()
    func onPushNotificationsValueChange(_ newValue: Bool)
    func onEmailNotificationsValueChange(_ newValue: Bool)
}

class SettingsPresenter: SettingsEventHandler {
    
    // MARK: - Properties
    
    private let userService: UserService
    
    weak var viewController: SettingsView?
    
    var isUserAuthorized: Bool {
        return userService.isAuthorized
    }
    var isPushNotificationsEnabled: Bool {
        return userService.isPushNotificationsEnabled
    }
    var isEmailNotificationsEnabled: Bool {
        return userService.isEmailNotificationsEnabled
    }
    
    // MARK: - Init
    
    init(storage: SettingsStorage) {
        userService = storage.userService
    }
    
    // MARK: - SettingsEventHandler
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onLanguageButtonTap() {
        let rawUrl = UIApplication.openSettingsURLString
        if let url = URL(string: rawUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func onPushNotificationsValueChange(_ newValue: Bool) {
        userService.isPushNotificationsEnabled = newValue
    }
    
    func onEmailNotificationsValueChange(_ newValue: Bool) {
        userService.isEmailNotificationsEnabled = newValue
    }
    
}
