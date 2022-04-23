//
//  Product.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import StoreKit

public protocol Product: SKProduct {
    var id: String { get }
    var localizedPrice: String { get }
}
