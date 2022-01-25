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
    
    private let accountConfirmationService: AccountConfirmationProvider
    private let userService: UserProvider
    private let jwtService: JWTService
    
    private var viewData: AccountConfirmationViewData
    
    // MARK: - Init
    
    init(storage: AccountConfirmationStorage) {
        delayManager = DefaultDelayManager(minimumDuration: 0.5)
        viewData = AccountConfirmationViewData(code: "", error: nil)
        
        accountConfirmationService = storage.accountConfirmationService
        userService = storage.userService
        jwtService = storage.jwtService
    }
    
    // MARK: - AccountConfirmationEventHandler
    
    func onViewLoad() {
        viewController?.viewData = viewData
        viewController?.setStatus(.success)
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onCodeChange(_ newText: String) {
        viewData.code = newText
        viewController?.viewData = viewData
    }
    
    func onConfirmButtonTap() {
        Task {
            do {
                let token = try await accountConfirmationService.confirmAccount(data: .init(email: userService.currentUser?.email ?? "", code: viewData.code ?? ""))
                
                // update token and fetch user
                jwtService.updateToken(token)
                fetchUser()
            } catch {
                handleConfirmationError(error as? NetworkError)
            }
        }
    }
    
    func onChangeAccountButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    private func fetchUser() {
        Task {
            do {
                try await userService.fetchUser()
                await viewController?.closeController(animated: true, completion: nil)
            } catch {
                RunLoop.main.perform(inModes: [.common]) {
                    self.viewController?.setStatus(.success)
                }
            }
        }
    }
    
    private func handleConfirmationError(_ error: NetworkError?) {
        guard let error = error else {
            return
        }
        
        
    }
    
}

