//
//  Route.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

public final class Route {
    public let id: String
    public let name: String
    public let description: String
    public let coverUrl: String?
    public let duration: String
    public let distance: String
    public let personsInfo: [PersonInfo]
    public var purchase: Purchase
    public let achievement: RouteAchievement?
    
    public init(id: String, name: String, description: String, coverUrl: String?, duration: String, distance: String, personsInfo: [PersonInfo], purchase: Purchase, achievement: RouteAchievement?) {
        self.id = id
        self.name = name
        self.description = description
        self.coverUrl = coverUrl
        self.duration = duration
        self.distance = distance
        self.personsInfo = personsInfo
        self.purchase = purchase
        self.achievement = achievement
    }
}

public extension Route {
    func localizedPrice() -> String {
        switch purchase.status {
        case .free:
            return "purchase.free".localized
            
        case .purchased:
            return "purchase.purchased".localized
            
        case .buy:
            return String(format: "purchase.buy".localized, purchase.product?.localizedPrice ?? "0")
        }
    }
}

extension Route: Equatable {
    public static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
}
