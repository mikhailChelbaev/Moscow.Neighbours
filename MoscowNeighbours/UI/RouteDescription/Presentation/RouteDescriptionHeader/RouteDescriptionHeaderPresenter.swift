//
//  RouteDescriptionHeaderPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import Foundation

protocol RouteDescriptionHeaderView {
    func display(_ viewModel: RouteDescriptionHeaderViewModel)
}

protocol PurchaseErrorView {
    func display(_ viewModel: PurchaseErrorViewModel)
}

struct PurchaseErrorViewModel {
    let title: String?
    let subtitle: String
    let actions: [AlertAction]
    let errorType: PurchasesError
}

final class RouteDescriptionHeaderPresenter {
    
    private let model: RouteDescriptionViewModel
    private let purchaseService: PurchaseRouteProvider
    private let startRoutePassing: Action
    private let purchaseOperationCompletion: Action
    private let showAuthorizationScreen: Action
    private let showVerificationScreen: Action
    
    init(model: RouteDescriptionViewModel,
         purchaseService: PurchaseRouteProvider,
         startRoutePassing: @escaping Action,
         purchaseOperationCompletion: @escaping Action,
         showAuthorizationScreen: @escaping Action,
         showVerificationScreen: @escaping Action) {
        self.model = model
        self.purchaseService = purchaseService
        self.startRoutePassing = startRoutePassing
        self.purchaseOperationCompletion = purchaseOperationCompletion
        self.showAuthorizationScreen = showAuthorizationScreen
        self.showVerificationScreen = showVerificationScreen
    }
    
    var view: RouteDescriptionHeaderView?
    var errorView: PurchaseErrorView?
    
    private var isPurchasingProduct: Bool = false
    private lazy var buttonTapAction: Action = { [weak self] in
        guard let self = self, !self.isPurchasingProduct else { return }
        if self.model.purchaseStatus == .buy {
            self.purchaseProduct()
        } else {
            self.startRoutePassing()
        }
    }
    
    func didRequestData() {
        updateView()
    }
    
    private func purchaseProduct() {
        guard !isPurchasingProduct else { return }
        
        isPurchasingProduct = true
        updateView()
        
        purchaseService.purchaseRoute(route: model.route) { [weak self] result in
            self?.isPurchasingProduct = false
            
            if case let Result.failure(error) = result {
                self?.handlePurchaseError(error)
            }
            
            self?.purchaseOperationCompletion()
        }
    }
    
    private func updateView() {
        let buttonTitle = isPurchasingProduct ? "" : model.buttonTitle
        view?.display(RouteDescriptionHeaderViewModel(
            title: model.name,
            information: model.information,
            buttonTitle: buttonTitle,
            coverURL: model.coverUrl,
            isLoading: isPurchasingProduct,
            didTapButton: buttonTapAction))
    }
    
    private func handlePurchaseError(_ error: Error) {
        switch error as? PurchasesError {
        case .purchaseInProgress:
            errorView?.display(PurchaseErrorViewModel(
                title: "purchase.purchase_in_progress_title".localized,
                subtitle: "purchase.purchase_in_progress_subtitle".localized,
                actions: [AlertAction(title: "common.ok".localized, style: .default, completion: nil)],
                errorType: .purchaseInProgress))
            
        case .paymentsRestricted:
            errorView?.display(PurchaseErrorViewModel(
                title: "purchase.payments_restricted_title".localized,
                subtitle: "purchase.payments_restricted_subtitle".localized,
                actions: [AlertAction(title: "common.ok".localized, style: .default, completion: nil)],
                errorType: .paymentsRestricted))
            
        case .userNotAuthorized:
            errorView?.display(PurchaseErrorViewModel(
                title: "purchase.user_not_authorized_title".localized,
                subtitle: "purchase.user_not_authorized_subtitle".localized,
                actions: [
                    AlertAction(title: "purchase.authorize".localized, style: .default, completion: { [weak self] in
                        self?.showAuthorizationScreen()
                    }),
                    AlertAction(title: "common.later".localized, style: .cancel)],
                errorType: .userNotAuthorized))
            
        case .userNotVerified:
            errorView?.display(PurchaseErrorViewModel(
                title: "purchase.user_not_verified_title".localized,
                subtitle: "purchase.user_not_verified_subtitle".localized,
                actions: [
                    AlertAction(title: "purchase.verify_account".localized, style: .default, completion: { [weak self] in
                        self?.showVerificationScreen()
                    }),
                    AlertAction(title: "common.later".localized, style: .cancel)],
                errorType: .userNotVerified))
            
        default:
            errorView?.display(PurchaseErrorViewModel(
                title: nil,
                subtitle: "purchase.purchase_unknown_error_subtitle".localized,
                actions: [AlertAction(title: "common.ok".localized, style: .default, completion: nil)],
                errorType: .unknown))
        }
    }
    
}
