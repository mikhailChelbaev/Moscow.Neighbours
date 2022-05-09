//
//  AchievementsService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import Foundation

final class AchievementsService: AchievementsProvider {
    
    typealias Result = AchievementsProvider.Result
    
    func retrieveAchievements(completion: @escaping (Result) -> Void) {
        completion(.success([
            AchievementsSection(
                title: "Полученные",
                achievements: [
                    Achievement(name: "Окрестности армянского переулка",
                                imageURL: "some url",
                                date: Date())
                ]),
            AchievementsSection(
                title: "Доступные",
                achievements: [
                    Achievement(name: "Окрестности армянского переулка",
                                imageURL: "some url",
                                date: Date()),
                    Achievement(name: "Рядом с писателями и художниками",
                                imageURL: "some url",
                                date: nil),
                    Achievement(name: "Уголки замоскворечья",
                                imageURL: "some url",
                                date: nil)
                ]),
        ]))
    }
    
}

extension AchievementsService {
    private struct AchievementsResponse: Decodable {
        struct Achievement: Decodable {
            let id: UUID
            let name: String
            let date: Date?
            let imageURL: String
        }
        
        struct AchievementsSection: Decodable {
            let title: String
            let achievements: [Achievement]
        }
        
        let sections: AchievementsSection
    }
}
