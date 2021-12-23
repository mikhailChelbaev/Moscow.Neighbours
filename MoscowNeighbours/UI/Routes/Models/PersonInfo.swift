//
//  PersonInfo.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation
import MapKit

class PersonInfo: NSObject, Codable {
    
    let id: String
    
    let person: Person
    
    let place: Place
    
    let coordinates: LocationCoordinates
    
    init(person: Person, place: Place, coordinates: LocationCoordinates) {
        self.id = UUID().uuidString
        self.person = person
        self.place = place
        self.coordinates = coordinates
    }
    
}

extension PersonInfo: MKAnnotation {
    
    var title: String? {
        person.name
    }
    
    var subtitle: String? {
        place.address
    }
    
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
}

extension PersonInfo {
    
    static var dummy: PersonInfo = .init(
        person: .dummy,
        place: .dummy,
        coordinates: .dummy
    )
    
}
