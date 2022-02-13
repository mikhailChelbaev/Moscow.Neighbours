//
//  RouteViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

final class RouteViewModel {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()
    
    let id: String
    let name: String
    var description: NSAttributedString
    let coverUrl: String?
    let routeInformation: String
    var persons: [PersonViewModel]
    let price: String
    var purchaseStatus: Route.Purchase.Status
    let productId: String?
    
    let route: Route
    
    init(from route: Route) {
        self.route = route
        
        id = route.id
        name = route.name
        description = NSAttributedString()
        coverUrl = route.coverUrl
        routeInformation = "\(route.distance) • \(route.duration)"
        price = route.localizedPriceText()
        purchaseStatus = route.purchase.status
        productId = route.purchase.productId
        persons = []
        
        for person in route.personsInfo {
            persons.append(PersonViewModel(from: person))
        }
        
        description = parse(text: route.description)
    }
    
    func update() {
        description = parse(text: route.description)
        for person in persons {
            person.update()
        }
    }
    
    func parse(text: String) -> NSAttributedString {
        parser.parse(text: text)
    }
    
    func updatePurchaseStatus(_ status: Route.Purchase.Status) {
        route.purchase.status = status
        purchaseStatus = status
    }
}
