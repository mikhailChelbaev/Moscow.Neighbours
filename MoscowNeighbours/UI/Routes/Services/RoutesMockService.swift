//
//  RoutesMockService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.02.2022.
//

import Foundation

final class RoutesMockService: RoutesProvider {
    
    // MARK: - Internal Methods
    
    func fetchRoutes() async throws -> [Route] {
        do {
            let path = Bundle.main.path(forResource: "routes", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let routes = try decoder.decode([Route].self, from: data)
            return routes
        }
        catch {
            throw error
        }
    }
    
}
