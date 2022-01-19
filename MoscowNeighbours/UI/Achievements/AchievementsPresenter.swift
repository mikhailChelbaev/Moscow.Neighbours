//
//  AchievementsPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import Foundation

protocol AchievementsEventHandler {
    func onLoadData()
    func onBackButtonTap()
    func onReloadButton()
}

class AchievementsPresenter: AchievementsEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: AchievementsView?
    
    private let delayManager: DelayManager
    
    // MARK: - Init
    
    init(storage: AchievementsStorage) {
        delayManager = DefaultDelayManager(minimumDuration: 0.5)
    }
    
    // MARK: - AchievementsEventHandler
    
    func onLoadData() {
        viewController?.updateErrorStatus(exact: .main)
    }
    
    func onBackButtonTap() {
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onReloadButton() {
        viewController?.status = .loading
        
        delayManager.start()
        delayManager.completeWithDelay {
            self.viewController?.updateErrorStatus(exact: nil)
        }
    }
    
}
