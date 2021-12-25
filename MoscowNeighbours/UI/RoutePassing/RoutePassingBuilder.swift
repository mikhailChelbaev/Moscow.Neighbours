//
//  RoutePassingBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

struct RoutePassingStorage {
    let route: RouteViewModel
    let personBuilder: PersonBuilder
}

protocol RoutePassingBuilder {
    func buildRoutePassingViewController(route: RouteViewModel) -> RoutePassingViewController
}

extension Builder: RoutePassingBuilder {
    func buildRoutePassingViewController(route: RouteViewModel) -> RoutePassingViewController {
        let storage = RoutePassingStorage(route: route,
                                          personBuilder: self)
        let presenter = RoutePassingPresenter(storage: storage)
        let viewController = RoutePassingViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
