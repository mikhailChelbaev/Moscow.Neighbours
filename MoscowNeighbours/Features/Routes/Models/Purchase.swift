//
//  Purchase.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

public struct Purchase {
    public enum Status: String {
        case free
        case buy
        case purchased
    }
    
    public var status: Status
    public let product: Product?
    
    public init(status: Purchase.Status, product: Product?) {
        self.status = status
        self.product = product
    }
}
