//
//  RouteViewControllerTests+LoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import MoscowNeighbours

extension RouteViewControllerTests {
    final class LoaderSpy: RoutesProvider {
        var completions = [(RoutesProvider.Result) -> Void]()
        
        func fetchRoutes(completion: @escaping (RoutesProvider.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeRoutesLoading(with routes: [Route] = [], at index: Int = 0) {
            completions[index](.success(routes))
        }
        
        func completeRoutesLoading(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
}
