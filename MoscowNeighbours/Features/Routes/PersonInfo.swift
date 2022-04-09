//
//  PersonInfo.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation
import MapKit

public final class PersonInfo: NSObject {
    public let id: String
    public let person: Person
    public let place: Place
    public let coordinates: LocationCoordinates
    
    public init(id: String, person: Person, place: Place, coordinates: LocationCoordinates) {
        self.id = id
        self.person = person
        self.place = place
        self.coordinates = coordinates
    }
}

extension PersonInfo: MKAnnotation {
    public var title: String? {
        person.name
    }
    
    public var subtitle: String? {
        place.address
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return .init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
