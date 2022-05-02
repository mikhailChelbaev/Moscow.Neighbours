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
    let actions: [(title: String?, style: ActionStyle)]
    let errorType: PurchasesError
}

final class RouteDescriptionHeaderPresenter {
    
    private let model: RouteDescriptionViewModel
    private let purchaseService: PurchaseWithConfirmationProvider
    private let startRoutePassing: Action
    private let purchaseOperationCompletion: Action
    
    init(model: RouteDescriptionViewModel,
         purchaseService: PurchaseWithConfirmationProvider,
         startRoutePassing: @escaping Action,
         purchaseOperationCompletion: @escaping Action) {
        self.model = model
        self.purchaseService = purchaseService
        self.startRoutePassing = startRoutePassing
        self.purchaseOperationCompletion = purchaseOperationCompletion
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
                actions: [(title: "common.ok".localized, style: .default)],
                errorType: .purchaseInProgress))
            
        default:
            errorView?.display(PurchaseErrorViewModel(
                title: "purchase.payments_restricted_title".localized,
                subtitle: "purchase.payments_restricted_subtitle".localized,
                actions: [(title: "common.ok".localized, style: .default)],
                errorType: .paymentsRestricted))
        }
    }
    
}
