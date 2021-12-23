//
//  Person.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

struct Person: Codable {
    
    let name: String
    
    let description: String
    
    let shortDescription: String
    
    let avatarUrl: String?
    
    let info: [ShortInfo]
    
}

extension Person {
    
    static var dummy: Person = .init(
        name: "",
        description: "",
        shortDescription: "",
        avatarUrl: nil,
        info: []
    )
    
}

