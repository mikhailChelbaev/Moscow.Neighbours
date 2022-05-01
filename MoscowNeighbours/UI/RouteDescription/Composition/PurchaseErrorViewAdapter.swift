//
//  PurchaseErrorViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.04.2022.
//

import Foundation

final class PurchaseErrorViewAdapter: PurchaseErrorView {
    private let coordinator: RouteDescriptionCoordinator
    
    init(coordinator: RouteDescriptionCoordinator) {
        self.coordinator = coordinator
    }
    
    func display(_ viewModel: PurchaseErrorViewModel) {
        switch viewModel.errorType {
        case .purchaseInProgress:
            coordinator.showPurchaseInProgressAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
            
        default:
            coordinator.showPaymentsRestrictedAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
        }
        
    }
}
