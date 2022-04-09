//
//  RoutesProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.02.2022.
//

import Foundation

protocol RoutesProvider {
    typealias Result = Swift.Result<[Route], NetworkError>
    
    func fetchRoutes(completion: @escaping (Result) -> Void)
}
