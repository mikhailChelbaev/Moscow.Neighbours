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
