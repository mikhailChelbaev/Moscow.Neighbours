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
    
    func onLoadData()
    func onBackButtonTap()
    func onAuthorizationButtonTap()
}

class MenuPresenter: MenuEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: MenuView?
    
    private let authorizationBuilder: AuthorizationBuilder
    
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
        userService = storage.userService
    }
    
    // MARK: - MenuEventHandler
    
    func onLoadData() {
        
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onAuthorizationButtonTap() {
        let controller = authorizationBuilder.buildAuthorizationViewController()
        viewController?.present(controller, state: .top, completion: nil)
    }
    
}
