//
//  AchievementsPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

protocol AchievementsView {
    func display(_ viewModel: AchievementsViewModel)
}

struct AchievementsViewModel {
    
}

protocol AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel)
}

protocol AchievementsLoadingView {
    func display(isLoading: Bool)
}

struct AchievementsHeaderViewModel {
    let title: String
}

final class AchievementsPresenter {
    
    private let achievementsProvider: AchievementsProvider
    
    init(achievementsProvider: AchievementsProvider) {
        self.achievementsProvider = achievementsProvider
    }
    
    var view: AchievementsView?
    var headerView: AchievementsHeaderView?
    var loadingView: AchievementsLoadingView?
    
    private static var headerTitle: String {
        return "achievements.title".localized
    }
    
    func didLoadHeader() {
        headerView?.display(AchievementsHeaderViewModel(title: AchievementsPresenter.headerTitle))
    }
    
    func didRequestAchievements() {
        loadingView?.display(isLoading: true)
        achievementsProvider.retrieveAchievements { [weak self] result in
            self?.view?.display(AchievementsViewModel())
        }
    }
    
}
