//
//  RouteViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

public struct RouteViewModel {
    public let name: String
    public let description: NSAttributedString
    public let coverUrl: String?
    public let routeInformation: String
    public let persons: [PersonInfo]
    public let purchaseStatus: Purchase.Status
    public let product: Product?
    public let price: String
    
    public init(name: String, description: NSAttributedString, coverUrl: String?, distance: String, duration: String, persons: [PersonInfo], purchaseStatus: Purchase.Status, product: Product?, price: String) {
        self.name = name
        self.description = description
        self.coverUrl = coverUrl
        self.routeInformation = "\(distance) • \(duration)"
        self.persons = persons
        self.purchaseStatus = purchaseStatus
        self.product = product
        self.price = price
    }
}
