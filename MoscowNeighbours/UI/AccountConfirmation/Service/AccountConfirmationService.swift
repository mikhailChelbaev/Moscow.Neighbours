//
//  AccountConfirmationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.01.2022.
//

import Foundation

protocol AccountConfirmationProvider {
    func confirmAccount(data: AccountConfirmationRequest) async throws -> JWTResponse
}

final class AccountConfirmationService: BaseNetworkService, AccountConfirmationProvider {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func confirmAccount(data: AccountConfirmationRequest) async throws -> JWTResponse {
        let result = await requestSender.send(request: api.confirmAccount(body: data),
                                              type: JWTResponse.self)
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
    func confirmAccount(body: AccountConfirmationRequest) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/auth/confirm", body: body, method: .post)
    }
}
