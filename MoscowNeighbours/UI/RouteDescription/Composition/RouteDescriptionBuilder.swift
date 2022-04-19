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

extension Builder {
    public func makeRouteDescriptionStorage<Transformer: ItemTransformer>(model: Route) -> RouteDescriptionStorage<Transformer> where Transformer.Input == Route, Transformer.Output == RouteViewModel {
        return RouteDescriptionStorage(model: model, routeTransformer: RouteTransformer() as! Transformer)
    }
}

public final class RoutesDescriptionUIComposer {
    private init() {}
    
    public static func routeDescriptionComposeWith<Transformer: ItemTransformer>(storage: RouteDescriptionStorage<Transformer>) -> RouteDescriptionViewController where Transformer.Input == Route, Transformer.Output == RouteViewModel {
        let presenter = RouteDescriptionPresenter(
            model: storage.model,
            routeTransformer: RouteTransformerMainQueueDispatchDecorator(decoratee: storage.routeTransformer))
        let tableViewController = RouteDescriptionTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: {
            
        })
        let controller = RouteDescriptionViewController(
            presenter: presenter,
            tableViewController: tableViewController,
            backButtonController: backButtonController)
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(controller: tableViewController)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
