//
//  RemoteAchievements.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.05.2022.
//

import Foundation

struct RemoteAchievements: Decodable {
    struct Achievement: Decodable {
        let id: UUID
        let name: String
        let description: String
        let date: Date?
        let imageUrl: String
    }
    
    let title: String
    let achievements: [Achievement]
    
    
}

extension RemoteAchievements {
    func toModel() -> AchievementsSection {
        AchievementsSection(
            title: title,
            achievements: achievements.map { $0.toModel() })
    }
}

extension RemoteAchievements.Achievement {
    func toModel() -> Achievement {
        Achievement(
            id: id,
            name: name,
            description: description,
            imageURL: imageUrl,
            date: date)
    }
}
