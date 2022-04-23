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
    
    init(controller: RouteDescriptionTableViewController, coordinator: RouteDescriptionCoordinator) {
        self.controller = controller
        self.coordinator = coordinator
    }
    
    func display(_ viewModel: RouteDescriptionViewModel) {
        let routeHeaderPresenter = RouteDescriptionHeaderPresenter(model: viewModel, startRoutePassing: { [weak coordinator] in
            coordinator?.startPassingRoute()
        })
        let routeHeaderController = RouteDescriptionHeaderViewController(presenter: routeHeaderPresenter)
        routeHeaderPresenter.view = WeakRef(routeHeaderController)
        
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
                    return PersonCellController(viewModel: personViewModel, coordinator: coordinator)
                })
        ]
        controller?.status = .success
    }
}
