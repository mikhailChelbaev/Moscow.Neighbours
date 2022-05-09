//
//  AchievementsViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 10.05.2022.
//

import Foundation

final class AchievementsViewAdapter: AchievementsView {
    private weak var controller: AchievementsTableViewController?
    
    init(controller: AchievementsTableViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: AchievementsViewModel) {
        controller?.tableModels = viewModel.sections
            .map { sectionViewModel in
                let textHeaderController = TextHeaderCellController(viewModel: TextHeaderCellViewModel(text: sectionViewModel.title))
                let achievementsCollectionCell = AchievementsCollectionCellController(viewModels: sectionViewModel.achievements)
                return TableSection(
                    header: textHeaderController,
                    footer: nil,
                    cells: [achievementsCollectionCell])
            }
        controller?.status = .success
    }
}
