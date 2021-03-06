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

protocol AchievementsErrorView {
    func display(_ viewModel: AchievementsErrorViewModel)
}

protocol AchievementDescriptionView {
    func display(_ viewModel: AchievementDescriptionViewModel)
}

struct AchievementDescriptionViewModel {
    let title: String
    let subtitle: String
    let imageURL: String
    let buttonTitle: String
}

final class AchievementsPresenter {
    
    private let achievementsProvider: AchievementsProvider
    
    init(achievementsProvider: AchievementsProvider) {
        self.achievementsProvider = achievementsProvider
    }
    
    var view: AchievementsView?
    var headerView: AchievementsHeaderView?
    var loadingView: AchievementsLoadingView?
    var errorView: AchievementsErrorView?
    var achievementDescriptionView: AchievementDescriptionView?
    
    var backButtonAction: Action?
    
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
            switch result {
            case let .success(sections):
                self?.view?.display(AchievementsViewModel(sections: sections.map { section in
                    AchievementSectionViewModel(
                        title: section.title,
                        achievements: section.achievements.map { achievement in
                            AchievementViewModel(
                                name: achievement.name,
                                imageURL: achievement.imageURL,
                                date: self?.mapAchievementReceiveDate(achievement.date),
                                onCellTap: { [weak self] in
                                    self?.onAchievementCellTap(achievement)
                                })
                        })
                }))
                
            case .failure:
                self?.errorView?.display(AchievementsErrorViewModel(retryAction: { [weak self] in
                    self?.didRequestAchievements()
                }))
            }
        }
    }
    
    private func onAchievementCellTap(_ achievement: Achievement) {
        achievementDescriptionView?.display(AchievementDescriptionViewModel(
            title: achievement.name,
            subtitle: achievement.description,
            imageURL: achievement.imageURL,
            buttonTitle: "achievements.alert_button_done".localized))
    }
    
    private func mapAchievementReceiveDate(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
    
}
