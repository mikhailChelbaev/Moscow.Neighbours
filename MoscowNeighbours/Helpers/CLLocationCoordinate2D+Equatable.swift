//
//  CLLocationCoordinate2D+Equatable.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.08.2021.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}
