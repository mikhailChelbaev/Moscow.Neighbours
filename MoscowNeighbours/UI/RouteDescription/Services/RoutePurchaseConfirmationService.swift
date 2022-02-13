//
//  RoutePurchaseConfirmationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

protocol RoutePurchaseConfirmationProvider {
    func confirmRoutePurchase(routeId: String) async throws
}

final class RoutePurchaseConfirmationService: BaseNetworkService, RoutePurchaseConfirmationProvider {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func confirmRoutePurchase(routeId: String) async throws {
        let result = await requestSender.send(request: api.makeRoutePurchaseConfirmationRequest(routeId: routeId),
                                              type: MessageResponse.self)
        
        if case let .failure(error) = result {
            throw error
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    func makeRoutePurchaseConfirmationRequest(routeId: String) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/routes/purchase/\(routeId)",
                           method: .post)
    }
}
