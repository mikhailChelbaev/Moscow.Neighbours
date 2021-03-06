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
    private let userState: UserState
    private let logoutManager: LogoutManager
    
    private var viewData: AccountConfirmationViewData
    
    private var successfulConfirmationCompletion: Action?
    
    // MARK: - Init
    
    init(storage: AccountConfirmationStorage) {
        delayManager = DefaultDelayManager(minimumDuration: 0.5)
        viewData = AccountConfirmationViewData(code: "", error: nil)
        
        accountConfirmationService = storage.accountConfirmationService
        userService = storage.userService
        jwtService = storage.jwtService
        userState = storage.userState
        logoutManager = storage.logoutManager
        
        successfulConfirmationCompletion = storage.successfulConfirmationCompletion
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
                let token = try await accountConfirmationService.confirmAccount(data: .init(email: userState.currentUser?.email ?? "", code: viewData.code ?? ""))
                
                // update token and fetch user
                jwtService.updateToken(token)
                fetchUser()
            } catch (let error as NetworkError) {
                await handleConfirmationError(error)
            }
        }
    }
    
    func onChangeAccountButtonTap() {
        logoutManager.logout()
        viewController?.closeController(animated: true, completion: nil)
    }
    
    private func fetchUser() {
        Task {
            do {
                let user = try await userService.fetchUser()
                userState.currentUser = user
                await viewController?.closeController(animated: true, completion: { [weak self] in
                    self?.successfulConfirmationCompletion?()
                })
            } catch {
                // TODO: - show error
                RunLoop.main.perform(inModes: [.common]) {
                    self.viewController?.setStatus(.success)
                }
            }
        }
    }
    
    @MainActor
    private func handleConfirmationError(_ error: NetworkError) {        
        switch error.type {
        case .http(statusCode: let statusCode):
            if statusCode == 400 {
                viewData.error = "account_confirmation.wrong_code".localized
                viewController?.viewData = viewData
                viewController?.setStatus(.success)
            } else {
                fallthrough
            }
            
        default:
            viewController?.showMainError()
        }
    }
    
}

