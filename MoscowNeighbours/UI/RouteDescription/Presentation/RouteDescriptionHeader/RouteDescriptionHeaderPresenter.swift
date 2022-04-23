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

final class RouteDescriptionHeaderPresenter {
    
    private let model: RouteDescriptionViewModel
    private let purchaseService: PurchaseOperationProvider
    private let startRoutePassing: Action
    private let purchaseOperationCompletion: Action
    
    init(model: RouteDescriptionViewModel,
         purchaseService: PurchaseOperationProvider,
         startRoutePassing: @escaping Action,
         purchaseOperationCompletion: @escaping Action) {
        self.model = model
        self.purchaseService = purchaseService
        self.startRoutePassing = startRoutePassing
        self.purchaseOperationCompletion = purchaseOperationCompletion
    }
    
    var view: RouteDescriptionHeaderView?
    
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
        guard !isPurchasingProduct, let product = model.product else { return }
        
        isPurchasingProduct = true
        updateView()
        
        purchaseService.purchaseProduct(product: product) { [weak self] result in
            self?.isPurchasingProduct = false
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
    
}
