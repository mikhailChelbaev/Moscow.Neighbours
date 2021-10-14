//
//  Place.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

struct Place: Codable {
    
    let id: String
    
    let name: String
    
    let description: String
    
    let address: String
    
}

extension Place {
    
    static var dummy: Place = .init(
        id: "",
        name: "",
        description: "",
        address: ""
    )
    
}
