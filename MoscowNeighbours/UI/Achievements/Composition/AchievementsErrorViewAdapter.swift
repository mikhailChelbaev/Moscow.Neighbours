//
//  AchievementsErrorViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 10.05.2022.
//

import Foundation

final class AchievementsErrorViewAdapter: AchievementsErrorView {
    private weak var controller: AchievementsTableViewController?
    
    init(controller: AchievementsTableViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: AchievementsErrorViewModel) {
        controller?.status = .error(DefaultEmptyStateProviders.mainError(action: viewModel.retryAction))
    }
}
