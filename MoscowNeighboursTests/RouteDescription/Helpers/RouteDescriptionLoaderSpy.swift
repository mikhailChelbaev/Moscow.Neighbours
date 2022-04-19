//
//  RouteDescriptionLoaderSpy.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import MoscowNeighbours

final class RouteDescriptionLoaderSpy: ItemTransformer {
    var transformationCompletions = [(RouteViewModel) -> Void]()
    
    var transfromCallCount: Int {
        return transformationCompletions.count
    }
    
    func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
        transformationCompletions.append(completion)
    }
    
    func completeRoutesTransforming(with route: RouteViewModel, at index: Int = 0) {
        transformationCompletions[index](route)
    }
}
