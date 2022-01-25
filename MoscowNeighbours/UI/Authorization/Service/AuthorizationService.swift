//
//  AuthorizationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.01.2022.
//

import Foundation

protocol AuthorizationProvider {
    func signIn(credentials: SignInModel) async throws -> JWTResponse
    func signUp(credentials: SignUpModel) async throws -> SignUpResponse
}

class AuthorizationService: BaseNetworkService {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func signIn(credentials: SignInModel) async throws -> JWTResponse {
        let dto = SignInDto(from: credentials)
        let result = await requestSender.send(request: api.signInRequest(body: dto),
                                              type: JWTResponse.self)
        switch result {
        case .success(let model):
            return model
            
        case .failure(let error):
            throw error
        }
    }
    
    func signUp(credentials: SignUpModel) async throws -> SignUpResponse {
        let dto = SignUpDto(from: credentials)
        let result = await requestSender.send(request: api.signUpRequest(body: dto),
                                              type: SignUpResponse.self)
        
        switch result {
        case .success(let model):
            return model
            
        case .failure(let error):
            throw error
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

