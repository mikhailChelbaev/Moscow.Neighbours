//
//  LocationCoordinates.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

struct LocationCoordinates: Codable {
    
    let latitude: Double
    
    let longitude: Double
    
}

extension LocationCoordinates {
    
    static var dummy: LocationCoordinates = .init(
        latitude: 0,
        longitude: 0
    )
    
}
