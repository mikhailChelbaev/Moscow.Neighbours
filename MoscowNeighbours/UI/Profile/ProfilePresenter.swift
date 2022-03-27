//
//  ProfilePresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.01.2022.
//

import UIKit

protocol ProfileEventHandler {
    func onLoadData()
    func onBackButtonTap()
    func onExitButtonTap()
}

class ProfilePresenter: ProfileEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: ProfileView?
    
    private let userState: UserState
    private let logoutManager: LogoutManager
    
    // MARK: - Init
    
    init(storage: ProfileStorage) {
        userState = storage.userState
        logoutManager = storage.logoutManager
    }
    
    // MARK: - ProfileEventHandler
    
    func onLoadData() {
        viewController?.userModel = userState.currentUser
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onExitButtonTap() {
        let presentingController = viewController?.presentingViewController as? MenuViewController
        let alertController = UIAlertController(title: "profile.exit_title".localized,
                                                message: "profile.exit_message".localized,
                                                preferredStyle: .alert)
        let yes = UIAlertAction(title: "common.yes".localized, style: .default, handler: { [weak self] _ in
            self?.logoutManager.logout()
            presentingController?.reloadData()
            self?.viewController?.closeController(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "common.cancel".localized, style: .cancel)
        alertController.addAction(yes)
        alertController.addAction(no)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
}

