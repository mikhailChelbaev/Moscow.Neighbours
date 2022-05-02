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
            coordinator.displayPurchaseInProgressAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
            
        case .paymentsRestricted:
            coordinator.displayPaymentsRestrictedAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
            
        case .userNotAuthorized:
            coordinator.displayUserNotAuthorizedAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
            
        case .userNotVerified:
            coordinator.displayUserNotVerifiedAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
            
        default:
            coordinator.displayAlert(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                actions: viewModel.actions)
        }
        
    }
}
