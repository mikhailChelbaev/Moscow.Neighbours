//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import UIKit

protocol RoutesServiceOutput: AnyObject {
    func fetchDataSucceeded(_ model: [Route])
    func fetchDataFailed(_ error: NetworkError)
}

class RoutesService: BaseNetworkService<RoutesServiceOutput> {
    
    // MARK: - Internal Methods
    
    func fetchRoutes() {
        requestSender.send(request: ApiRequestsFactory.main.routesRequest,
                           type: [Route].self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.observers.forEach({ $0.value.fetchDataSucceeded(model) })
                
            case .failure(let error):
                self?.observers.forEach({ $0.value.fetchDataFailed(error) })
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
