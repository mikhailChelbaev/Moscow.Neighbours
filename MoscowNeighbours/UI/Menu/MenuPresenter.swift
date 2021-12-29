//
//  MenuPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

protocol MenuEventHandler {
    func onLoadData()
    func onBackButtonTap()
    func onAuthorizationButtonTap()
}

class MenuPresenter: MenuEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: MenuView?
    
    private let authorizationBuilder: AuthorizationBuilder
    
    // MARK: - Init
    
    init(storage: MenuStorage) {
        authorizationBuilder = storage.authorizationBuilder
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
