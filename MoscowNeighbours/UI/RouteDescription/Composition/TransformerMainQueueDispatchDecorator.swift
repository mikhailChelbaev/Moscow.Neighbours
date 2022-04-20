//
//  TransformerMainQueueDispatchDecorator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import Foundation

final class TransformerMainQueueDispatchDecorator<Transformer: ItemTransformer, Input, Output>: ItemTransformer where Transformer.Input == Input, Transformer.Output == Output  {
    private let decoratee: Transformer
    
    init(decoratee: Transformer) {
        self.decoratee = decoratee
    }

    func transform(_ route: Input, completion: @escaping (Output) -> Void) {
        decoratee.transform(route) { result in
            guard Thread.isMainThread else {
                return DispatchQueue.main.async(execute: { completion(result) })
            }
            
            completion(result)
        }
    }
}
