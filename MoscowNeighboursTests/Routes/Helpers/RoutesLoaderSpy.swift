//
//  RoutesLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import MoscowNeighbours

final class RoutesLoaderSpy: RoutesProvider, RoutesStateObserver {
    
    // MARK: - RoutesProvider
    
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
    
    // MARK: - RoutesStateObserver
    
    private var observers = [String: RoutesStateObserver.Observer]()
    
    func observe(for key: String, completion: @escaping RoutesStateObserver.Observer) {
        observers[key] = completion
    }
    
    func notifyAboutRoutesChange(with routes: [Route]) {
        observers.forEach { $0.value(routes) }
    }
}
