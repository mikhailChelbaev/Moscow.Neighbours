//
//  AccountConfirmationPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import Foundation

protocol AccountConfirmationEventHandler {
    func onViewLoad()
    func onBackButtonTap()
    func onCodeChange(_ newText: String)
    func onConfirmButtonTap()
    func onChangeAccountButtonTap()
}

class AccountConfirmationPresenter: AccountConfirmationEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AccountConfirmationView?
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: AccountConfirmationStorage) {
        delayManager = DefaultDelayManager(minimumDuration: 0.5)
    }
    
    // MARK: - AccountConfirmationEventHandler
    
    func onViewLoad() {
        viewController?.viewData = AccountConfirmationViewData(code: "", error: nil)
        viewController?.setStatus(.success)
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onCodeChange(_ newText: String) {
        viewController?.viewData?.code = newText
    }
    
    func onConfirmButtonTap() {
        
    }
    
    func onChangeAccountButtonTap() {
        
    }
    
}

