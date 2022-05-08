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
        let presenter = AchievementsPresenter(achievementsProvider: achievementsProvider)
        let controller = AchievementsViewController(
            presenter: presenter,
            tableViewController: tableViewController)
        
        presenter.view = AchievementsViewAdapter(controller: tableViewController)
        presenter.headerView = WeakRef(controller)
        presenter.loadingView = tableViewController
        
        return controller
    }
}

extension WeakRef: AchievementsHeaderView where T: AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel) {
        object?.display(viewModel)
    }
}

final class AchievementsViewAdapter: AchievementsView {
    private weak var controller: AchievementsTableViewController?
    
    init(controller: AchievementsTableViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: AchievementsViewModel) {
        controller?.tableModels = []
        controller?.status = .success
    }
}
