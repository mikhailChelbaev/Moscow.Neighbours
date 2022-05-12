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
        return AchievementsUIComposer.achievementsComposeWith(achievementsProvider: achievementsService)
    }
}

public final class AchievementsUIComposer {
    private init() {}
    
    public static func achievementsComposeWith(achievementsProvider: AchievementsProvider) -> AchievementsViewController {
        let tableViewController = AchievementsTableViewController()
        let presenter = AchievementsPresenter(achievementsProvider: MainQueueDispatchDecorator(decoratee: achievementsProvider))
        let controller = AchievementsViewController(
            presenter: presenter,
            tableViewController: tableViewController)
        
        presenter.view = AchievementsViewAdapter(controller: tableViewController)
        presenter.errorView = AchievementsErrorViewAdapter(controller: tableViewController)
        presenter.headerView = WeakRef(controller)
        presenter.loadingView = tableViewController
        presenter.achievementDescriptionView = AchievementDescriptionViewAdapter(controller: controller)
        
        presenter.backButtonAction = { [weak controller] in
            controller?.closeController(animated: true)
        }
        
        return controller
    }
}
