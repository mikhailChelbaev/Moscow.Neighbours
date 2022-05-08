//
//  AchievementsBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

protocol AchievementsBuilder {
    func buildAchievementsViewController() -> AchievementsViewController
}

extension Builder: AchievementsBuilder {
    func buildAchievementsViewController() -> AchievementsViewController {
        let achievementsService = AchievementsService()
        return AchievementsUIComposer.achievementsComposeWith(achievementsProvider: achievementsService)
    }
}

public final class AchievementsUIComposer {
    private init() {}
    
    public static func achievementsComposeWith(achievementsProvider: AchievementsProvider) -> AchievementsViewController {
        let presenter = AchievementsPresenter()
        let controller = AchievementsViewController(presenter: presenter)
        
        presenter.headerView = WeakRef(controller)
        
        return controller
    }
}

extension WeakRef: AchievementsHeaderView where T: AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel) {
        object?.display(viewModel)
    }
}
