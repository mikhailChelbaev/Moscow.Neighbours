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

public final class RoutesDescriptionUIComposer {
    private init() {}
    
    public static func routeDescriptionComposeWith<Transformer: ItemTransformer>(storage: RouteDescriptionStorage<Transformer>, coordinator: RouteDescriptionCoordinator) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel {
        let presenter = RouteDescriptionPresenter(
            model: storage.model,
            routeTransformer: RouteTransformerMainQueueDispatchDecorator(decoratee: storage.routeTransformer))
        let tableViewController = RouteDescriptionTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: { [weak coordinator] in
            coordinator?.dismiss(animated: true, completion: nil)
        })
        let controller = RouteDescriptionViewController(
            presenter: presenter,
            coordinator: coordinator,
            tableViewController: tableViewController,
            backButtonController: backButtonController)
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(controller: tableViewController)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
