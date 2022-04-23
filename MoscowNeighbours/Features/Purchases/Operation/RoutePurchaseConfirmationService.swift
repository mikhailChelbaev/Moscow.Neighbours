//
//  RoutePurchaseConfirmationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

public protocol RoutePurchaseConfirmationProvider {
    typealias Result = Swift.Result<Void, Error>
    
    func confirmRoutePurchase(routeId: String, completion: ((Result) -> Void)?)
}

final class RoutePurchaseConfirmationService: BaseNetworkService, RoutePurchaseConfirmationProvider {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    typealias Result = RoutePurchaseConfirmationProvider.Result
    
    func confirmRoutePurchase(routeId: String, completion: ((Result) -> Void)?) {
        Task {
            let result = await requestSender.send(request: api.makeRoutePurchaseConfirmationRequest(routeId: routeId),
                                                  type: MessageResponse.self)
            
            switch result {
            case .success:
                completion?(.success(()))
                
            case let .failure(error):
                Logger.log("Failed to confirm route purchase: \(error.localizedDescription)")
                completion?(.failure(error))
            }
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
