//
//  DelayManager.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

public protocol DelayManager {
    func start()
    func completeWithDelay(_ completion: Action?)
}

public final class DefaultDelayManager: DelayManager {
    private let minimumDuration: TimeInterval
    private var startFetchingDate: Date = .init()
    
    public init(minimumDuration: TimeInterval = 1.0) {
        self.minimumDuration = minimumDuration
    }
    
    public func start() {
        startFetchingDate = .init()
    }
    
    public func completeWithDelay(_ completion: Action?) {
        let delay: TimeInterval = max(0, minimumDuration - Date().timeIntervalSince(startFetchingDate))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion?()
        }
    }
}
