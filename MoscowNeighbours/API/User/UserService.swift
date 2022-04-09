//
//  UserService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

final class UserService: BaseNetworkService, UserProvider {
    
    // MARK: - Private Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory = .main) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func fetchUser() async throws -> UserModel {
        let result = await requestSender.send(request: api.userRequest, type: UserModel.self)
        
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
    var userRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/me", method: .get)
    }
}
