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
    private let startRoutePassing: Action
    
    init(model: RouteDescriptionViewModel, startRoutePassing: @escaping Action) {
        self.model = model
        self.startRoutePassing = startRoutePassing
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
        guard !isPurchasingProduct else { return }
        
        isPurchasingProduct = true
        
        updateView()
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
