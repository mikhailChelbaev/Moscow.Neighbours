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
        let tableViewController = AchievementsTableViewController()
        let presenter = AchievementsPresenter(achievementsProvider: MainQueueDispatchDecorator(decoratee: achievementsProvider))
        let controller = AchievementsViewController(
            presenter: presenter,
            tableViewController: tableViewController)
        
        presenter.view = AchievementsViewAdapter(controller: tableViewController)
        presenter.errorView = AchievementsErrorViewAdapter(controller: tableViewController)
        presenter.headerView = WeakRef(controller)
        presenter.loadingView = tableViewController
        
        presenter.backButtonAction = { [weak controller] in
            controller?.closeController(animated: true)
        }
        presenter.onAchievementCellTap = { [weak controller] achievement in
            let alertCell = AchievementAlertCell()
            alertCell.update()
            let alertController = AlertController(view: alertCell, configuration: .init(margins: .init(top: 20, left: 20, bottom: 20, right: 20)))
            controller?.present(alertController, animated: true)
        }
        
        return controller
    }
}
