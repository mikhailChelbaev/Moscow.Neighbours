//
//  SharedTestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation
import MoscowNeighbours
import StoreKit

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

extension SKProduct {
    convenience init(id: String, price: NSDecimalNumber) {
        self.init()
        self.setValue(id, forKey: "productIdentifier")
        self.setValue(price, forKey: "price")
        self.setValue(Locale.current, forKey: "priceLocale")
    }
}

func makeRoute(name: String = "Route", price: (status: Purchase.Status, value: NSDecimalNumber?) = (.free, nil), personsInfo: [PersonInfo] = []) -> Route {
    let product: MoscowNeighbours.Product = SKProduct(id: UUID().uuidString, price: price.value ?? 0)
    return Route(
        id: UUID().uuidString,
        name: "some name",
        description: "description",
        coverUrl: nil,
        duration: "200 min",
        distance: "200 km",
        personsInfo: personsInfo,
        purchase: .init(
            status: price.status,
            product: price.status == .free ? nil : product))
}

func makePersonInfo() -> PersonInfo {
    return PersonInfo(
        id: UUID().uuidString,
        person: makePerson(),
        place: makePlace(),
        coordinates: makeLocationCoordinates())
}

func makePerson() -> Person {
    return Person(
        name: "person name",
        description: "person description",
        shortDescription: "person short description",
        avatarUrl: nil,
        info: [])
}

func makePlace() -> Place {
    return Place(
        id: UUID().uuidString,
        name: "place name",
        description: "place description",
        address: "place address")
}

func makeLocationCoordinates() -> LocationCoordinates {
    LocationCoordinates(
        latitude: 1.0,
        longitude: 1.0)
}

func makeRouteModel(from route: Route = makeRoute()) -> RouteViewModel {
    return RouteViewModel(
        name: route.name,
        description: NSAttributedString(string: route.description),
        coverUrl: route.coverUrl,
        distance: route.distance,
        duration: route.duration,
        persons: route.personsInfo,
        purchaseStatus: route.purchase.status,
        product: route.purchase.product,
        price: route.localizedPrice())
}
