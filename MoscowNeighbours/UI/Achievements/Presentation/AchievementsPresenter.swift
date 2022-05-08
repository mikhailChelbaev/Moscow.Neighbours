//
//  AchievementsPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

protocol AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel)
}

struct AchievementsHeaderViewModel {
    let title: String
}

final class AchievementsPresenter {
    
    var headerView: AchievementsHeaderView?
    
    private static var headerTitle: String {
        return "achievements.title".localized
    }
    
    func didLoadHeader() {
        headerView?.display(AchievementsHeaderViewModel(title: AchievementsPresenter.headerTitle))
    }
    
    func didRequestAchievements() {
        
    }
    
}
