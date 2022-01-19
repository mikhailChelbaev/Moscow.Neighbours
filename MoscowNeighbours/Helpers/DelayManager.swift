//
//  DelayManager.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

protocol DelayManager {
    func start()
    func completeWithDelay(_ completion: Action?)
}

final class DefaultDelayManager: DelayManager {
    let minimumDuration: TimeInterval
    private var startFetchingDate: Date = .init()
    
    init(minimumDuration: TimeInterval = 1.0) {
        self.minimumDuration = minimumDuration
    }
    
    func start() {
        startFetchingDate = .init()
    }
    
    func completeWithDelay(_ completion: Action?) {
        let delay: TimeInterval = max(0, minimumDuration - Date().timeIntervalSince(startFetchingDate))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion?()
        }
    }
}
