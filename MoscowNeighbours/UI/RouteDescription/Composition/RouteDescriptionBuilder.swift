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
    let mapService: MapService
    
    public init(model: Route, routeTransformer: Transformer, mapService: MapService) {
        self.model = model
        self.routeTransformer = routeTransformer
        self.mapService = mapService
    }
}

public final class RoutesDescriptionUIComposer {
    private init() {}
    
    public static func routeDescriptionComposeWith<Transformer: ItemTransformer>(storage: RouteDescriptionStorage<Transformer>, coordinator: RouteDescriptionCoordinator) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel {
        let closeCompletion: Action? = { [weak coordinator] in
            storage.mapService.hideRoute()
            coordinator?.dismiss(animated: true, completion: nil)
        }
        
        let presenter = RouteDescriptionPresenter(
            model: storage.model,
            routeTransformer: TransformerMainQueueDispatchDecorator(decoratee: storage.routeTransformer))
        let tableViewController = RouteDescriptionTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: closeCompletion)
        let controller = RouteDescriptionViewController(
            presenter: presenter,
            coordinator: coordinator,
            tableViewController: tableViewController,
            backButtonController: backButtonController,
            didShowRoute: {
                storage.mapService.showRoute(storage.model.personsInfo)
            })
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(controller: tableViewController, coordinator: coordinator)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
