//
//  AuthorizationPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

protocol AuthorizationEventHandler {
    func onBackButtonTap()
}

class AuthorizationPresenter: AuthorizationEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AuthorizationView?
    
    // MARK: - Init
    
    init(storage: AuthorizationStorage) {
        
    }
    
    // MARK: - AuthorizationEventHandler
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
}
