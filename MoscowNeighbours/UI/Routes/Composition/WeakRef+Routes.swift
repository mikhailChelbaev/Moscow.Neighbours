//
//  WeakRef+Routes.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.04.2022.
//

import Foundation

extension WeakRef: RoutesView where T: RoutesView {
    func display(routes: [Route]) {
        object?.display(routes: routes)
    }
}

extension WeakRef: RouteErrorView where T: RouteErrorView {
    func display(error: Error) {
        object?.display(error: error)
    }
}

extension WeakRef: RouteLoadingView where T: RouteLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

extension WeakRef: RouteDescriptionPresenterView where T: RouteDescriptionPresenterView {
    func presentRouteDescription(for route: Route) {
        object?.presentRouteDescription(for: route)
    }
}
