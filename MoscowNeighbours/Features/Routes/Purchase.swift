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
    public let productId: String?
    
    public init(status: Purchase.Status, productId: String?) {
        self.status = status
        self.productId = productId
    }
}
