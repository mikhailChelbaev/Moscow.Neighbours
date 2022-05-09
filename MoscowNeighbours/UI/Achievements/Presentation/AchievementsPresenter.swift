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

protocol AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel)
}

protocol AchievementsLoadingView {
    func display(isLoading: Bool)
}

final class AchievementsPresenter {
    
    private let achievementsProvider: AchievementsProvider
    
    init(achievementsProvider: AchievementsProvider) {
        self.achievementsProvider = achievementsProvider
    }
    
    var view: AchievementsView?
    var headerView: AchievementsHeaderView?
    var loadingView: AchievementsLoadingView?
    
    var backButtonAction: Action?
    var onAchievementCellTap: ((Achievement) -> Void)?
    
    private static var headerTitle: String {
        return "achievements.title".localized
    }
    
    func didLoadHeader() {
        headerView?.display(AchievementsHeaderViewModel(
            title: AchievementsPresenter.headerTitle,
            backButtonAction: { [weak self] in
                self?.backButtonAction?()
            }
        ))
    }
    
    func didRequestAchievements() {
        loadingView?.display(isLoading: true)
        achievementsProvider.retrieveAchievements { [weak self] result in
            self?.view?.display(AchievementsViewModel(sections: [
                AchievementSectionViewModel(
                    title: "My achievements",
                    achievements: [
                        AchievementViewModel(onCellTap: { [weak self] in
                            self?.onAchievementCellTap?(Achievement(name: "name", imageURL: "dsfd", date: nil))
                        }),
                        AchievementViewModel(onCellTap: { [weak self] in
                            self?.onAchievementCellTap?(Achievement(name: "name", imageURL: "dsfd", date: nil))
                        }),
                    ]),
//                AchievementSectionViewModel(
//                    title: "Available achievements",
//                    achievements: [
//                        AchievementViewModel(),
//                        AchievementViewModel(),
//                        AchievementViewModel(),
//                        AchievementViewModel()
//                    ]),
            ]))
        }
    }
    
}
