//
//  MainQueueDispatchDecorator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}
