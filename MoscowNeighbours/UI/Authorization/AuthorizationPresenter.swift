//
//  AuthorizationPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import Foundation
import AuthenticationServices

protocol AuthorizationEventHandler {
    var signInModel: SignInModel { set get }
    var signUpModel: SignUpModel { set get }
    
    func onBackButtonTap()
    func onAuthorizationTypeTap(_ type: AuthorizationType)
    
    func onSignInButtonTap()
    func onSignInWithAppleButtonTap()
    func onSignUpButtonTap()
}

class AuthorizationPresenter: NSObject, AuthorizationEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AuthorizationView?
    
    var signInModel: SignInModel
    var signUpModel: SignUpModel
    
    private var authorizationService: AuthorizationService
    private var jwtService: JWTService
    private var userState: UserState
    private var userService: UserProvider
    
    private let accountConfirmationBuilder: AccountConfirmationBuilder
    
    // MARK: - Init
    
    init(storage: AuthorizationStorage) {
        signInModel = .init()
        signUpModel = .init()
        
        authorizationService = storage.authorizationService
        jwtService = storage.jwtService
        userState = storage.userState
        userService = storage.userService
        
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
                } catch (let error as NetworkError) {
                    await handleSignInError(error: error)
                }
            }
        } else {
            viewController?.reloadData()
        }
    }
    
    // MARK: - Sign Up
    
    func onSignUpButtonTap() {
        if validateSignUpInputedData() {
            viewController?.status = .loading
            Task {
                do {
                    // fetch signUpResponse
                    let signUpResponse = try await authorizationService.signUp(credentials: signUpModel)
                    let userModel = UserModel(from: signUpResponse)
                    userState.currentUser = userModel
                    
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
                            self.showAccountConfirmation()
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
        
        signUpErrorModel.email = EmailValidator.isValid(email: signUpModel.email)
        signUpErrorModel.username = UsernameValidator.isValid(username: signUpModel.username)
        signUpErrorModel.password = PasswordValidator.isValid(password: signUpModel.password)
        
        viewController?.updateSignUpError(signUpErrorModel)
        
        return signUpErrorModel.isEmpty
    }
    
    private func fetchUser() {
        Task {
            do {
                let user = try await userService.fetchUser()
                userState.currentUser = user
                await viewController?.closeController(animated: true, completion: nil)
            } catch {
                RunLoop.main.perform(inModes: [.common]) {
                    self.viewController?.status = .success
                }
            }
        }
    }
    
    @MainActor
    private func handleSignInError(error: NetworkError) {
        switch error.description {
        case .notVerified:
            let model = UserModel(name: "", email: signInModel.username, isVerified: false)
            userState.currentUser = model
            showAccountConfirmation()
            
        default:
            viewController?.handleSignInError(error)
        }
    }
    
    private func showAccountConfirmation() {
        let controller = accountConfirmationBuilder.buildAccountConfirmationViewController(withChangeAccountButton: true) { [weak self] in
            self?.viewController?.closeController(animated: true, completion: nil)
        }
        viewController?.present(controller, state: .top, completion: nil)
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
