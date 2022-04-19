//
//  Person.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

public struct Person {
    public let name: String
    public let description: String
    public let shortDescription: String
    public let avatarUrl: String?
    public let info: [ShortInfo]
    
    public init(name: String, description: String, shortDescription: String, avatarUrl: String?, info: [ShortInfo]) {
        self.name = name
        self.description = description
        self.shortDescription = shortDescription
        self.avatarUrl = avatarUrl
        self.info = info
    }
}

