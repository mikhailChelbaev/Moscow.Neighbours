//
//  TestDelayManager.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import MoscowNeighbours

final class TestDelayManager: DelayManager {
    func start() {}
    
    func completeWithDelay(_ completion: Action?) {
        completion?()
    }
}
