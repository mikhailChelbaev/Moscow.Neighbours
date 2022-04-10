//
//  RouteViewControllerTests+FakeStoreContainer.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 10.04.2022.
//

import MoscowNeighbours

extension RouteViewControllerTests {
    final class FakeStoreContainer: StoreContainer {
        func store<T>(data: T, key: String) where T : Decodable, T : Encodable {}
        func get<T>(key: String) -> T? where T : Decodable, T : Encodable {
            return nil
        }
        func reset() {}
    }
}
