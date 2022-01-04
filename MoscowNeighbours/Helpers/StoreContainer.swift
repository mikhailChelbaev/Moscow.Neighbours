//
//  StoreContainer.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

protocol StoreContainer {
    func store<T>(data: T, key: String) where T: Codable
    func get<T>(key: String) -> T? where T: Codable
    func reset()
}

extension UserDefaults: StoreContainer {

    func get<T>(key: String) -> T? where T: Decodable, T: Encodable {
        let decoder = JSONDecoder()
        guard let data = self.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    func store<T>(data: T, key: String) where T: Codable {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(data) {
            self.set(json, forKey: key)
        }
    }

    func reset() {
        self.dictionaryRepresentation().keys.forEach(self.removeObject(forKey:))
    }

}

