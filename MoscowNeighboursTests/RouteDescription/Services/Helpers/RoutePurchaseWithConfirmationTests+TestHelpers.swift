//
//  PurchaseRouteCompositionServiceTests+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 24.04.2022.
//

import MoscowNeighbours

extension PurchaseRouteCompositionServiceTests {
    
    func anyPaidRoute() -> Route {
        return makeRoute(price: (.buy, 200))
    }
    
}
