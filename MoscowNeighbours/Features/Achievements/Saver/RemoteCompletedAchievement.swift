//
//  RemoteCompletedAchievement.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.05.2022.
//

import Foundation

struct RemoteCompletedAchievement: Encodable {
    let achievementId: UUID
    let date: String
}

extension RemoteCompletedAchievement {
    static func from(_ model: CompletedAchievement) -> RemoteCompletedAchievement {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return RemoteCompletedAchievement(achievementId: model.id, date: dateFormatter.string(from: model.date))
    }
}
