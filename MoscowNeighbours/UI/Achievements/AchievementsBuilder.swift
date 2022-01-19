//
//  AchievementsBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

struct AchievementsStorage {
}

protocol AchievementsBuilder {
    func buildAchievementsViewController() -> AchievementsViewController
}

extension Builder: AchievementsBuilder {
    func buildAchievementsViewController() -> AchievementsViewController {
        let presenter = AchievementsPresenter(storage: buildStorage())
        let viewController = AchievementsViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
    
    private func buildStorage() -> AchievementsStorage {
        return AchievementsStorage()
    }
}
