//
//  MainQueueDispatchDecorator+RouteDescription.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import Foundation

extension MainQueueDispatchDecorator: PurchaseRouteProvider where T == PurchaseRouteProvider {
    func purchaseRoute(route: Route, completion: @escaping (PurchaseRouteProvider.Result) -> Void) {
        decoratee.purchaseRoute(route: route) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
