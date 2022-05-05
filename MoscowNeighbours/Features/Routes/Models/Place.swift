//
//  Place.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

public struct Place: Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let address: String
    
    public init(id: String, name: String, description: String?, address: String) {
        self.id = id
        self.name = name
        self.description = description
        self.address = address
    }
}
