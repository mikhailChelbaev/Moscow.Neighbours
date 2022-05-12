//
//  AchievementsSaver.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.05.2022.
//

import Foundation

protocol AchievementsSaver {
    typealias Result = Swift.Result<(), Error>
    
    func storeAchievement(_ completedAchievement: CompletedAchievement, completion: @escaping (Result) -> Void)
}

extension AchievementsSaver {
    func storeAchievementIgnoringResult(_ completedAchievement: CompletedAchievement) {
        storeAchievement(completedAchievement) { _ in }
    }
}
