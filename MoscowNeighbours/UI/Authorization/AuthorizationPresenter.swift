//
//  AuthorizationPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation

protocol AuthorizationEventHandler {
    func onBackButtonTap()
    func onAuthorizationTypeTap(_ type: AuthorizationType)
    
    func onSignInUsernameTextChange(_ text: String)
    func onSignInPasswordTextChange(_ text: String)
    func onSignInButtonTap()
    
    func onSignUpUsernameTextChange(_ text: String)
    func onSignUpEmailTextChange(_ text: String)
    func onSignUpPasswordTextChange(_ text: String)
    func onSignUpButtonTap()
}

class AuthorizationPresenter: AuthorizationEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AuthorizationView?
    
    private var signInModel: SignInModel
    private var signUpModel: SignUpModel
    
    // MARK: - Init
    
    init(storage: AuthorizationStorage) {
        signInModel = .init()
        signUpModel = .init()
    }
    
    // MARK: - AuthorizationEventHandler
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onAuthorizationTypeTap(_ type: AuthorizationType) {
        guard type != viewController?.type else {
            return
        }
        
        viewController?.type = type
        viewController?.animateTypeChange()
    }
    
    // MARK: - Sign In
    
    func onSignInUsernameTextChange(_ text: String) {
        signInModel.username = text
        validateSignIn()
    }
    
    func onSignInPasswordTextChange(_ text: String) {
        signInModel.password = text
        validateSignIn()
    }
    
    func onSignInButtonTap() {
        
    }
    
    private func validateSignIn() {
        viewController?.signInButton?.isEnabled = signInModel.isValid
    }
    
    // MARK: - Sign Up
    
    func onSignUpUsernameTextChange(_ text: String) {
        signUpModel.username = text
        validateSignUp()
    }
    
    func onSignUpEmailTextChange(_ text: String) {
        signUpModel.email = text
        validateSignUp()
    }
    
    func onSignUpPasswordTextChange(_ text: String) {
        signUpModel.password = text
        validateSignUp()
    }
    
    func onSignUpButtonTap() {
        
    }
    
    private func validateSignUp() {
        viewController?.signUpButton?.isEnabled = signUpModel.isValid
    }
    
}
