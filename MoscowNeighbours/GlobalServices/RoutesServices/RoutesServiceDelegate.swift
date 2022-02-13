//
//  RoutesServiceDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

protocol RouteServiceDelegate {
    func didStartFetchingRoutes()
    func didFetchRoutes(_ routes: [Route])
    func didFailWhileRoutesFetch(error: NetworkError)
}
