//
//  RoutesProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

protocol RoutesProvider {
    var observers: [String: RouteServiceDelegate] { set get }
    
    func fetchRoutes()
}

extension RoutesProvider {
    mutating func register(_ output: RouteServiceDelegate) {
        observers[String(describing: output.self)] = output
    }
    
    mutating func remove(_ output: RouteServiceDelegate) {
        observers[String(describing: output.self)] = nil
    }
}
