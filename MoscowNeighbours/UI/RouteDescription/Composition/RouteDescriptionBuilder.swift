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
        
        presenter.routeDescriptionView = WeakRef(tableViewController)
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}

extension WeakRef: RouteDescriptionLoadingView where T: RouteDescriptionLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

extension WeakRef: RouteDescriptionView where T: RouteDescriptionView {
    func display(route: RouteViewModel) {
        object?.display(route: route)
    }
}

