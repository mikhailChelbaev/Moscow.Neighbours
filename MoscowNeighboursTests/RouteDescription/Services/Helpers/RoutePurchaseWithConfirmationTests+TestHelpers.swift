//
//  RoutePurchaseWithConfirmationTests+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 24.04.2022.
//

import MoscowNeighbours

extension RoutePurchaseWithConfirmationTests {
    
    func anyPaidRoute() -> Route {
        return makeRoute(price: (.buy, 200))
    }
    
}
