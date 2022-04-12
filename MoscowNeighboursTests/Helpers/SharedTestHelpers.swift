//
//  SharedTestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation
import MoscowNeighbours

func makeRoute(name: String = "Route", price: (status: Purchase.Status, value: String?) = (.free, nil)) -> Route {
    return Route(id: UUID().uuidString, name: "some name", description: "description", coverUrl: nil, duration: "200 min", distance: "200 km", personsInfo: [], purchase: .init(status: price.status, productId: nil), price: price.value)
}
