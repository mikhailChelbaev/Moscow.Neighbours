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
        completion(.success([]))
    }
    
}
