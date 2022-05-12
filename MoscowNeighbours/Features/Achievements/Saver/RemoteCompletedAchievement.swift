//
//  RemoteCompletedAchievement.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.05.2022.
//

import Foundation

struct RemoteCompletedAchievement: Encodable {
    let achievementId: UUID
    let date: Date
}

extension RemoteCompletedAchievement {
    static func from(_ model: CompletedAchievement) -> RemoteCompletedAchievement {
        return RemoteCompletedAchievement(achievementId: model.id, date: model.date)
    }
}
