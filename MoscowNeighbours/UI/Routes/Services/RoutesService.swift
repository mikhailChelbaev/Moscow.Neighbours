//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import UIKit

protocol RoutesProvider {
    func fetchRoutes() async throws -> [Route]
}

final class RoutesService: BaseNetworkService, RoutesProvider {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func fetchRoutes() async throws -> [Route] {
        let result = await requestSender.send(request: api.routesRequest,
                                              type: [Route].self)
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
    var routesRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/routes", method: .get)
    }
}
