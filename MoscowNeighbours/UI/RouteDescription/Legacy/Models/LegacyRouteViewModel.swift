//
//  RouteViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

final class LegacyRouteViewModel {
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        return DefaultMarkdownParser(configurator: config, withCache: false)
    }()

    let id: String
    let name: String
    var description: NSAttributedString
    let coverUrl: String?
    let routeInformation: String
    var persons: [LegacyPersonViewModel]
    var purchaseStatus: Purchase.Status
    let productId: String?
    var price: String

    let route: Route

    init(from route: Route) {
        self.route = route

        id = route.id
        name = route.name
        description = NSAttributedString()
        coverUrl = route.coverUrl
        routeInformation = "\(route.distance) • \(route.duration)"
        purchaseStatus = route.purchase.status
        persons = []
        productId = route.purchase.productId
        price = route.localizedPrice()

        for person in route.personsInfo {
            persons.append(LegacyPersonViewModel(from: person))
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

    func updatePurchaseStatus(_ status: Purchase.Status) {
        route.purchase.status = status
        purchaseStatus = status
        price = route.localizedPrice()
    }
}
