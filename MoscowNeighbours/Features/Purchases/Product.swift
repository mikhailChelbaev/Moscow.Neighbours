//
//  Product.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation

public protocol Product {
    var id: String { get }
    var localizedPrice: String { get }
}
