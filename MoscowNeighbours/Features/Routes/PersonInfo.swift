//
//  PersonInfo.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation
import MapKit

final class PersonInfo: NSObject {
    let id: String
    let person: Person
    let place: Place    
    let coordinates: LocationCoordinates
    
    init(id: String, person: Person, place: Place, coordinates: LocationCoordinates) {
        self.id = id
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
