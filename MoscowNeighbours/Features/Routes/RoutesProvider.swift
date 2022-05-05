//
//  RoutesProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

public protocol RoutesProvider {
    typealias Result = Swift.Result<[Route], Error>
    
    func fetchRoutes(completion: @escaping (Result) -> Void)
}

public protocol RoutesState {
    func updateRoute(_ route: Route)
}

public protocol RoutesStateObserver {
    typealias Observer = ([Route]) -> Void
    
    func observe(for key: String, completion: @escaping Observer)
}
