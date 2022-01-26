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
    private var userService: UserProvider
    
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
    
    private let accountConfirmationBuilder: AccountConfirmationBuilder
    
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
        
        accountConfirmationBuilder = storage.accountConfirmationBuilder
        
        super.init()
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
            Task {
                do {
                    // get token
                    let token = try await authorizationService.signIn(credentials: signInModel)
                    jwtService.updateToken(token)
                    
                    // fetch user
                    fetchUser()
                } catch {
                    await viewController?.handleSignInError(error as? NetworkError)
                }
            }
        } else {
            viewController?.reloadData()
        }
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
            Task {
                do {
                    // fetch signUpResponse
                    let signUpResponse = try await authorizationService.signUp(credentials: signUpModel)
                    let userModel = UserModel(from: signUpResponse)
                    userService.storeCurrentUser(userModel)
                    
                    if signUpResponse.isVerified {
                        // get token
                        let token = try await authorizationService.signIn(credentials: .init(username: signUpModel.email, password: signUpModel.password))
                        jwtService.updateToken(token)
                        
                        // fetch user
                        fetchUser()
                    } else {
                        // show account confirmation screen
                        DispatchQueue.main.async {
                            self.viewController?.status = .success
                            let controller = self.accountConfirmationBuilder.buildAccountConfirmationViewController(withChangeAccountButton: true) { [weak self] in
                                self?.viewController?.closeController(animated: true, completion: nil)
                            }
                            self.viewController?.present(controller, state: .top, completion: nil)
                        }
                    }
                } catch {
                    await viewController?.handleSignUpError(error as? NetworkError)
                }
            }
        } else {
            viewController?.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func validateSignInInputedData() -> Bool {
        var signInErrorsModel = SignInErrorsModel()
        
        if signInModel.username.isEmpty {
            signInErrorsModel.email = "auth.empty".localized
        }
        
        if signInModel.password.isEmpty {
            signInErrorsModel.password = "auth.empty".localized
        }
        
        viewController?.updateSignInError(signInErrorsModel)
        
        return signInErrorsModel.isEmpty
    }
    
    private func validateSignUpInputedData() -> Bool {
        var signUpErrorModel = SignUpErrorsModel()
        
        signUpErrorModel.email = emailValidator.isValid(email: signUpModel.email)
        signUpErrorModel.username = usernameValidator.isValid(username: signUpModel.username)
        signUpErrorModel.password = passwordValidator.isValid(password: signUpModel.password)
        
        viewController?.updateSignUpError(signUpErrorModel)
        
        return signUpErrorModel.isEmpty
    }
    
    private func fetchUser() {
        Task {
            do {
                try await userService.fetchUser()
                await viewController?.closeController(animated: true, completion: nil)
            } catch {
                RunLoop.main.perform(inModes: [.common]) {
                    self.viewController?.status = .success
                }
            }
        }
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
