//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

import Foundation

final class RoutesService: BaseNetworkService, RoutesProvider {
    
    // MARK: - Properties
    
    private let api: ApiRequestsFactory
    var observers: [String : RouteServiceDelegate]
    
    // MARK: - Init
    
    init(api: ApiRequestsFactory) {
        self.observers = [:]
        self.api = api
    }
    
    // MARK: - Internal Methods
    
    func fetchRoutes() {
        observers.forEach({ $0.value.didStartFetchingRoutes() })
        Task.detached { [self] in
            let result = await requestSender.send(request: api.routesRequest,
                                                  type: [Route].self)
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    observers.forEach({ $0.value.didFetchRoutes(model) })
                }
                
            case .failure(let error):
                Logger.log("Failed to load routes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    observers.forEach({ $0.value.didFailWhileRoutesFetch(error: error) })
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
