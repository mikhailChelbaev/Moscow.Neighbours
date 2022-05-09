//
//  MainQueueDispatchDecorator+Achievements.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 10.05.2022.
//

import Foundation

extension MainQueueDispatchDecorator: AchievementsProvider where T == AchievementsProvider {
    func retrieveAchievements(completion: @escaping (AchievementsProvider.Result) -> Void) {
        decoratee.retrieveAchievements { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
