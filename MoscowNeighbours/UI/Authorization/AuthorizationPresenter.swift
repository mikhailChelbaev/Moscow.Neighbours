//
//  AuthorizationPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation
import AuthenticationServices

protocol AuthorizationEventHandler {
    var signInUsername: String { get }
    var signInPassword: String { get }
    
    var signUpUsername: String { get }
    var signUpEmail: String { get }
    var signUpPassword: String { get }
    
    func onBackButtonTap()
    func onAuthorizationTypeTap(_ type: AuthorizationType)
    
    func onSignInUsernameTextChange(_ text: String)
    func onSignInPasswordTextChange(_ text: String)
    func onSignInButtonTap()
    func onSignInWithAppleButtonTap()
    
    func onSignUpUsernameTextChange(_ text: String)
    func onSignUpEmailTextChange(_ text: String)
    func onSignUpPasswordTextChange(_ text: String)
    func onSignUpButtonTap()
}

class AuthorizationPresenter: NSObject, AuthorizationEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AuthorizationView?
    
    private var authorizationService: AuthorizationService
    private var jwtService: JWTService
    private var userService: UserService
    
    private var signInModel: SignInModel
    private var signUpModel: SignUpModel
    
    var signInUsername: String {
        signInModel.username
    }
    var signInPassword: String {
        signInModel.password
    }
    
    var signUpUsername: String {
        signUpModel.username
    }
    var signUpEmail: String {
        signUpModel.email
    }
    var signUpPassword: String {
        signUpModel.password
    }
    
    private let emailValidator: EmailValidator
    private let usernameValidator: UsernameValidator
    private let passwordValidator: PasswordValidator
    
    // MARK: - Init
    
    init(storage: AuthorizationStorage) {
        signInModel = .init()
        signUpModel = .init()
        
        authorizationService = storage.authorizationService
        jwtService = storage.jwtService
        userService = storage.userService
        
        emailValidator = .init()
        usernameValidator = .init()
        passwordValidator = .init()
        
        super.init()
        
        authorizationService.register(WeakRef(self))
        userService.register(WeakRef(self))
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
    
    func onSignInWithAppleButtonTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // MARK: - Sign In
    
    func onSignInUsernameTextChange(_ text: String) {
        signInModel.username = text
    }
    
    func onSignInPasswordTextChange(_ text: String) {
        signInModel.password = text
    }
    
    func onSignInButtonTap() {
        if validateSignInInputedData() {
            viewController?.status = .loading
            authorizationService.signIn(credentials: signInModel)
        } else {
            viewController?.reloadData()
        }
    }
    
    private func validateSignInInputedData() -> Bool {
        if signInModel.username.isEmpty {
            viewController?.signInErrors.email = "auth.empty".localized
        } else {
            viewController?.signInErrors.email = nil
        }
        
        if signInModel.password.isEmpty {
            viewController?.signInErrors.password = "auth.empty".localized
        } else {
            viewController?.signInErrors.password = nil
        }
        
        return viewController?.signInErrors.email == nil &&
        viewController?.signInErrors.password == nil
    }
    
    // MARK: - Sign Up
    
    func onSignUpUsernameTextChange(_ text: String) {
        signUpModel.username = text
    }
    
    func onSignUpEmailTextChange(_ text: String) {
        signUpModel.email = text
    }
    
    func onSignUpPasswordTextChange(_ text: String) {
        signUpModel.password = text
    }
    
    func onSignUpButtonTap() {
        if validateSignUpInputedData() {
            viewController?.status = .loading
            authorizationService.signUp(credentials: signUpModel)
        } else {
            viewController?.reloadData()
        }
    }
    
    private func validateSignUpInputedData() -> Bool {
        viewController?.signUpErrors.email = emailValidator.isValid(email: signUpModel.email)
        viewController?.signUpErrors.username = usernameValidator.isValid(username: signUpModel.username)
        viewController?.signUpErrors.password = passwordValidator.isValid(password: signUpModel.password)
        
        return viewController?.signUpErrors.email == nil &&
        viewController?.signUpErrors.username == nil &&
        viewController?.signUpErrors.password == nil
    }
    
}

// MARK: - protocol ASAuthorizationControllerDelegate

extension AuthorizationPresenter: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
        }
    }
}

// MARK: - protocol AuthorizationServiceOutput

extension AuthorizationPresenter: AuthorizationServiceOutput {
    func didAuthorize(_ jwt: JWTResponse) {
        jwtService.updateToken(jwt)
        userService.fetchUser()
    }
    
    func authorizationDidCompleteWithError(_ error: NetworkError) {
        viewController?.status = .success
    }
}

// MARK: - protocol UserServiceOutput

extension AuthorizationPresenter: UserServiceOutput {
    func userFetched(_ model: UserModel) {
        guard let menuController = viewController?.presentingViewController as? MenuViewController else {
            return
        }
        menuController.reloadData()
        
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func userFetchFailed(_ error: NetworkError) {
    }
}
