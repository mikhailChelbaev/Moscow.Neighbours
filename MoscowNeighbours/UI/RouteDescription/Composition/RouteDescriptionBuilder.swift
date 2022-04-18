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
            routeTransformer: RouteTransformerMainQueueDispatchDecorator(decoratee: storage.routeTransformer))
        let tableViewController = RouteDescriptionTableViewController()
        let controller = RouteDescriptionViewController(presenter: presenter, tableViewController: tableViewController)
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(controller: tableViewController)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
