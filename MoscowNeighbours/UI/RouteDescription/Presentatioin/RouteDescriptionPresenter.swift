//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

protocol RouteDescriptionView {
    func display(route: RouteViewModel)
}

protocol RouteDescriptionLoadingView {
    func display(isLoading: Bool)
}

final class RouteDescriptionPresenter<RouteTransformer: ItemTransformer> where RouteTransformer.Input == Route, RouteTransformer.Output == RouteViewModel {
    private let model: Route
    private let routeTransformer: RouteTransformer
    
    init(model: Route, routeTransformer: RouteTransformer) {
        self.model = model
        self.routeTransformer = routeTransformer
    }
    
    var routeDescriptionView: RouteDescriptionView?
    var routeDescriptionLoadingView: RouteDescriptionLoadingView?
}

extension RouteDescriptionPresenter: RouteDescriptionInput {
    func didTransformRoute() {
        routeDescriptionLoadingView?.display(isLoading: true)
        routeTransformer.transform(model) { [weak self] route in
            self?.routeDescriptionView?.display(route: route)
        }
    }
}
