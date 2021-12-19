//
//  WeakRef+Routes.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.12.2021.
//

extension WeakRef: RoutesServiceOutput where T: RoutesServiceOutput {
    func fetchDataSucceeded(_ model: [Route]) {
        object?.fetchDataSucceeded(model)
    }
    
    func fetchDataFailed(_ error: NetworkError) {
        object?.fetchDataFailed(error)
    }
}
