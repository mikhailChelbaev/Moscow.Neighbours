//
//  SharedTestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation
import MoscowNeighbours

func makeRoute(name: String = "Route", price: (status: Purchase.Status, value: String?) = (.free, nil), personsInfo: [PersonInfo] = []) -> Route {
    return Route(id: UUID().uuidString, name: "some name", description: "description", coverUrl: nil, duration: "200 min", distance: "200 km", personsInfo: personsInfo, purchase: .init(status: price.status, productId: price.status == .free ? nil : UUID().uuidString), price: price.value)
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
        productId: route.purchase.productId,
        price: route.localizedPrice())
}
