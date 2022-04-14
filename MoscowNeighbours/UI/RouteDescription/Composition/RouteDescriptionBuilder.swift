//
//  RouteDescriptionBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

public struct RouteDescriptionStorage<Transformer: ItemTransformer> where Transformer.Input == Route, Transformer.Output == RouteViewModel {
    let model: Route
    let routeTransformer: Transformer
    
    public init(model: Route, routeTransformer: Transformer) {
        self.model = model
        self.routeTransformer = routeTransformer
    }
}

public protocol RoutesDescriptionBuilder {
    func buildRouteDescriptionViewController<Transformer: ItemTransformer>(storage: RouteDescriptionStorage<Transformer>) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel
}

extension Builder: RoutesDescriptionBuilder {
    public func buildRouteDescriptionViewController<Transformer: ItemTransformer>(storage: RouteDescriptionStorage<Transformer>) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel {
        let presenter = RouteDescriptionPresenter(
            model: storage.model,
            routeTransformer: storage.routeTransformer)
        let tableViewController = RouteDescriptionTableViewController()
        let controller = RouteDescriptionViewController(presenter: presenter, tableViewController: tableViewController)
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(controller: tableViewController)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}

private final class RouteDescriptionViewAdapter: RouteDescriptionView {
    private weak var controller: RouteDescriptionTableViewController?
    
    init(controller: RouteDescriptionTableViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: RouteDescriptionViewModel) {
        let routeHeaderViewModel = RouteDescriptionHeaderViewModel(
            title: viewModel.name,
            information: viewModel.information,
            buttonTitle: viewModel.buttonTitle,
            buttonAction: viewModel.buttonAction)
        let routeHeaderController = RouteDescriptionHeaderViewController(viewModel: routeHeaderViewModel)
        
        let descriptionHeaderCellModel = TextHeaderCellViewModel(text: viewModel.descriptionHeader)
        let descriptionHeaderCellController = TextHeaderCellController(viewModel: descriptionHeaderCellModel)
        
        let routeInformationCellModel = RouteInformationCellViewModel(text: viewModel.description)
        let routeInformationCellController = RouteInformationCellController(viewModel: routeInformationCellModel)
        
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
                    return PersonCellController(viewModel: personViewModel)
                })
        ]
        controller?.status = .success
    }
}

extension WeakRef: RouteDescriptionLoadingView where T: RouteDescriptionLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

extension WeakRef: RouteDescriptionView where T: RouteDescriptionView {
    func display(_ viewModel: RouteDescriptionViewModel) {
        object?.display(viewModel)
    }
}

