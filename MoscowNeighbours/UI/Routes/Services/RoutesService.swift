//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import UIKit

protocol RoutesServiceOutput: AnyObject {
    @MainActor func fetchDataSucceeded(_ model: [Route])
    @MainActor func fetchDataFailed(_ error: NetworkError)
}

class RoutesService: BaseNetworkService<RoutesServiceOutput> {
    
    // MARK: - Internal Properties
    
    private let api: ApiRequestsFactory
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func fetchRoutes() {
        Task {
            let result = await requestSender.send(request: api.routesRequest,
                                                  type: [Route].self)
            switch result {
            case .success(let model):
                for observer in observers {
                    await observer.value.fetchDataSucceeded(model)
                }
                
            case .failure(let error):
                for observer in observers {
                    await observer.value.fetchDataFailed(error)
                }
            }
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var routesRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/routes", method: .get)
    }
}
