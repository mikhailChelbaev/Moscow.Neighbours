//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.09.2021.
//

import Foundation

extension Requests {
    
    struct RoutesRequest: RequestPresentable {
        
        var url: URLRequest? {
            RequestPreparation.makeRequest(url: Constants.routes, method: .get)
        }
        
    }
    
}

final class RoutesService: BaseNetworkService {
    
    func fetchRoutes(completion: @escaping (RequestResult<[Route]>) -> Void) {
        requestSender.send(request: Requests.RoutesRequest(), type: [Route].self) { result in
            completion(result)
        }
    }
    
}
