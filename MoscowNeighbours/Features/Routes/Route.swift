//
//  Route.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

final class Route {
    let id: String
    let name: String
    let description: String
    let coverUrl: String?
    let duration: String
    let distance: String
    let personsInfo: [PersonInfo]
    var purchase: Purchase
    let price: String?
    
    init(id: String, name: String, description: String, coverUrl: String?, duration: String, distance: String, personsInfo: [PersonInfo], purchase: Purchase, price: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.coverUrl = coverUrl
        self.duration = duration
        self.distance = distance
        self.personsInfo = personsInfo
        self.purchase = purchase
        self.price = price
    }
}

extension Route {
    func localizedPrice() -> String {
        switch purchase.status {
        case .free:
            return "purchase.free".localized
            
        case .purchased:
            return "purchase.purchased".localized
            
        case .buy:
            return String(format: "purchase.buy".localized, price ?? "0")
        }
    }
}
