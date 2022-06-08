//
//  RouteDescriptionViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import Foundation

final class RouteDescriptionViewAdapter: RouteDescriptionView {
    private weak var controller: RouteDescriptionTableViewController?
    private let coordinator: RouteDescriptionCoordinator
    private let purchaseService: PurchaseRouteProvider
    private let purchaseErrorView: PurchaseErrorView
    private let onPersonCellTapAction: (PersonInfo) -> Void
    
    init(controller: RouteDescriptionTableViewController,
         coordinator: RouteDescriptionCoordinator,
         purchaseService: PurchaseRouteProvider,
         purchaseErrorView: PurchaseErrorView,
         onPersonCellTapAction: @escaping (PersonInfo) -> Void) {
        self.controller = controller
        self.coordinator = coordinator
        self.purchaseService = purchaseService
        self.purchaseErrorView = purchaseErrorView
        self.onPersonCellTapAction = onPersonCellTapAction
    }
    
    func display(_ viewModel: RouteDescriptionViewModel) {
        let routeHeaderPresenter = RouteDescriptionHeaderPresenter(
            model: viewModel,
            purchaseService: purchaseService,
            startRoutePassing: { [weak coordinator] in
                coordinator?.startPassingRoute()
            }, purchaseOperationCompletion: { isProductPurchasedSuccessfully in
                if isProductPurchasedSuccessfully {
                    viewModel.setPurchasedStatus()
                }
            }, showAuthorizationScreen: { [weak self] in
                self?.coordinator.displayAuthorization()
            }, showVerificationScreen: { [weak self] in
                self?.coordinator.displayVerification()
            })
        let routeHeaderController = RouteDescriptionHeaderViewController(presenter: routeHeaderPresenter)
        routeHeaderPresenter.view = WeakRef(routeHeaderController)
        routeHeaderPresenter.errorView = purchaseErrorView
        
        let descriptionHeaderCellModel = TextHeaderCellViewModel(text: viewModel.descriptionHeader)
        let descriptionHeaderCellController = TextHeaderCellController(viewModel: descriptionHeaderCellModel)
        
        let routeInformationCellModel = InformationCellViewModel(text: viewModel.description)
        let routeInformationCellController = InformationCellController(viewModel: routeInformationCellModel)
        
        let routeInformationSeparatorController = SeparatorCellController()
        
        let personsHeaderCellModel = TextHeaderCellViewModel(text: viewModel.personsHeader)
        let personsHeaderCellController = TextHeaderCellController(viewModel: personsHeaderCellModel)
        
        controller?.tableModels = [
            TableSection(cells: [
                routeHeaderController
            ]),
            TableSection(
                header: descriptionHeaderCellController,
                footer: nil,
                cells: [
                    routeInformationCellController,
                    routeInformationSeparatorController
                ]),
            TableSection(
                header: personsHeaderCellController,
                footer: nil,
                cells: viewModel.persons.map { personViewModel in
                    return PersonCellController(viewModel: personViewModel, onPersonCellTapAction: onPersonCellTapAction)
                })
        ]
        
        reloadTableView()
    }
    
    private func reloadTableView() {
        controller?.status = .success
    }
}
