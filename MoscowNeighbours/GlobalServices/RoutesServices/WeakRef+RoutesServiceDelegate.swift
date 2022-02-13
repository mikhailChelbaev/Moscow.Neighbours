//
//  WeakRef+RoutesServiceDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

extension WeakRef: RouteServiceDelegate where T: RouteServiceDelegate {
    func didStartFetchingRoutes() {
        object?.didStartFetchingRoutes()
    }
    
    func didFetchRoutes(_ routes: [Route]) {
        object?.didFetchRoutes(routes)
    }
    
    func didFailWhileRoutesFetch(error: NetworkError) {
        object?.didFailWhileRoutesFetch(error: error)
    }
}
