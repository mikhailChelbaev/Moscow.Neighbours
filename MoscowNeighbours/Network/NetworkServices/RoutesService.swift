//
//  RoutesService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.09.2021.
//

import Foundation

extension Requests {
    
    struct RoutesRequest: Request {
        
        var url: URLRequest? {
            if let url = URL(string: Constants.routes) {
                return RequestPreparation.get(url: url, params: nil)
            } else {
                return nil
            }
        }
        
    }
    
}

final class RoutesService: BaseNetworkService {
    
    func fetchRoutes(completion: @escaping ([Route]?) -> Void) {
        requestSender.send(request: Requests.RoutesRequest(), type: [Route].self) { result in
            switch result {
            case .success(let routes):
                completion(routes)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
//        completion(data)
    }
    
}
