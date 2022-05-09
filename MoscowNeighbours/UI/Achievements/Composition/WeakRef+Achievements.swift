//
//  WeakRef+Achievements.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 10.05.2022.
//

import Foundation

extension WeakRef: AchievementsHeaderView where T: AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel) {
        object?.display(viewModel)
    }
}
