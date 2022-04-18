//
//  RouteTransformerMainQueueDispatchDecorator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import Foundation

final class RouteTransformerMainQueueDispatchDecorator<Transformer: ItemTransformer>: ItemTransformer where Transformer.Input == Route, Transformer.Output == RouteViewModel  {
    private let decoratee: Transformer
    
    init(decoratee: Transformer) {
        self.decoratee = decoratee
    }

    func transform(_ route: Route, completion: @escaping (RouteViewModel) -> Void) {
        decoratee.transform(route) { result in
            guard Thread.isMainThread else {
                return DispatchQueue.main.async(execute: { completion(result) })
            }
            
            completion(result)
        }
    }
}
