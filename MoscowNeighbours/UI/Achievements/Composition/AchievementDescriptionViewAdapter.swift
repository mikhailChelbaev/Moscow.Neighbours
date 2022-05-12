//
//  AchievementDescriptionViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.05.2022.
//

import Foundation

final class AchievementDescriptionViewAdapter: AchievementDescriptionView {
    private weak var controller: AchievementsViewController?
    
    init(controller: AchievementsViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: AchievementDescriptionViewModel) {
        let alertCell = AchievementAlertCell()
        let alertController = AlertController(view: alertCell, configuration: .init(margins: .init(top: 20, left: 20, bottom: 20, right: 20)))
        alertCell.update(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            imageURL: viewModel.imageURL,
            buttonTitle: viewModel.buttonTitle,
            buttonAction: { [weak alertController] in
                alertController?.dismiss(animated: true)
            })
        controller?.present(alertController, animated: true)
    }
}
