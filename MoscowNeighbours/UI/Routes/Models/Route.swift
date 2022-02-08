//
//  Route.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

final class Route: Codable {
    
    struct Purchase: Codable {
        enum Status: String, Codable {
            case free // user should not pay for it
            case buy // user have to pay
            case paid // user has already paid
        }
        
        var status: Status
        let productId: String?
    }
    
    let id: String
    let name: String
    let description: String
    let coverUrl: String?
    let duration: String
    let distance: String
    let personsInfo: [PersonInfo]
    var purchase: Purchase
    
    var price: String?
}

extension Route {
    func localizedPriceText() -> String {
        switch purchase.status {
        case .free:
            return "For free"
            
        case .buy:
            return "Buy for \(price ?? "0")"
            
        case .paid:
            return "Already bought"
        }
    }
}
