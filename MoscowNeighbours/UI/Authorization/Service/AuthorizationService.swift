//
//  AuthorizationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.01.2022.
//

import Foundation

protocol AuthorizationServiceOutput: AnyObject {
    @MainActor func didAuthorize(_ jwt: JWTResponse)
    @MainActor func authorizationDidCompleteWithError(_ error: NetworkError)
}

class AuthorizationService: ObservableNetworkService<AuthorizationServiceOutput> {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func signIn(credentials: SignInModel) {
        Task {
            let dto = SignInDto(from: credentials)
            let result = await requestSender.send(request: api.signInRequest(body: dto),
                                                  type: JWTResponse.self)
            await authorizationCompletion(result: result)
        }
    }
    
    func signUp(credentials: SignUpModel) {
        Task {
            let dto = SignUpDto(from: credentials)
            let result = await requestSender.send(request: api.signUpRequest(body: dto),
                                                  type: JWTResponse.self)
            await authorizationCompletion(result: result)
        }
    }
    
    // MARK: - Private Methods
    
    private func authorizationCompletion(result: RequestResult<JWTResponse>) async {
        switch result {
        case .success(let model):
            for observer in observers {
                await observer.value.didAuthorize(model)
            }
            
        case .failure(let error):
            for observer in observers {
                await observer.value.authorizationDidCompleteWithError(error)
            }
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    func signInRequest(body: SignInDto) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/auth/signIn", body: body, method: .post)
    }
    
    func signUpRequest(body: SignUpDto) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/auth/signUp", body: body, method: .post)
    }
}

