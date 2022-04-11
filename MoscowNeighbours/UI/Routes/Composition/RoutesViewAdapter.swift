//
//  RoutesViewAdapter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.04.2022.
//

import Foundation

final class RoutesViewAdapter: RoutesView {
    private weak var controller: RouteViewController?
    
    init(controller: RouteViewController) {
        self.controller = controller
    }
    
    func display(routes: [Route]) {
        let tableModels = routes.map { route in
            return RouteCellController(model: route)
        }
        controller?.display(tableModels: tableModels)
    }
}
