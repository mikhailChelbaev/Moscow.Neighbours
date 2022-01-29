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
    func onFeedbackCellTap()
}

class SettingsPresenter: SettingsEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: SettingsView?
    
    private var userService: UserProvider
    private let mailService: EmailProvider
    
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
        mailService = storage.mailService
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
    
    func onFeedbackCellTap() {
        do {
            try mailService.showEmailComposer(recipient: "support.email".localized,
                                              subject: "support.subject".localized,
                                              content: nil,
                                              controller: viewController)
        } catch {
            if case .cantSendMail = error as? EmailServiceErrors {
                viewController?.handleUnableToShowMailError()
            }
        }
    }
    
}
