//
//  RouteFinder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.08.2021.
//

import Foundation
import MapKit

protocol RouteFinder {
    typealias RouteCoordinates = [(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D)]
    
    func findRoute(from coordinate: CLLocationCoordinate2D,
                   coordinates: [CLLocationCoordinate2D]) async -> RouteCoordinates
}

extension RouteFinder {
    
    func findNearestCoordinate(from coordinate: CLLocationCoordinate2D,
                               coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        var minValue: Double = .greatestFiniteMagnitude
        var nearestCoordinate: CLLocationCoordinate2D?
        for coord in coordinates {
            let dist = calculateCoordinatesDistance(p1: coordinate, p2: coord)
            if dist < minValue {
                minValue = dist
                nearestCoordinate = coord
            }
        }
        return nearestCoordinate
    }
    
    /*
     The ‘haversine’ formula to calculate the great-circle distance between two points.
     That is, the shortest distance over the earth’s surface – giving an ‘as-the-crow-flies’ distance between the points
     */
    func calculateCoordinatesDistance(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> Double {
        let r = 6371e3 // Earth radius
        let phi1 = p1.latitude * Double.pi / 180
        let phi2 = p2.latitude * Double.pi / 180
        let deltaPhi = abs(p1.latitude - p2.latitude) * Double.pi / 180
        let deltaLambda = abs(p1.longitude - p2.longitude) * Double.pi / 180
        
        let a = pow(sin(deltaPhi / 2), 2) + cos(phi1) * cos(phi2) * pow(sin(deltaLambda / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return r * c
    }
    
}

class NearestCoordinatesFinder: RouteFinder {
    
    private let queue = DispatchQueue(label: "NearestCoordinatesFinder", qos: .userInitiated)
    
    func findRoute(from coordinate: CLLocationCoordinate2D,
                   coordinates: [CLLocationCoordinate2D]) async -> RouteCoordinates {
        await withCheckedContinuation { continuation in
            queue.async {
                var currentCoordinate: CLLocationCoordinate2D = coordinate
                var remainingCoordinates: [CLLocationCoordinate2D] = coordinates
                var route: RouteCoordinates = []
                
                while remainingCoordinates.count > 1 {
                    if let nearestCoordinate = self.findNearestCoordinate(from: currentCoordinate, coordinates: remainingCoordinates) {
                        route.append((currentCoordinate, nearestCoordinate))
                        currentCoordinate = nearestCoordinate
                        if let index = remainingCoordinates.firstIndex(where: { $0 == nearestCoordinate }) {
                            remainingCoordinates.remove(at: index)
                        }
                    }
                }
                
                if let last = remainingCoordinates.last {
                    route.append((currentCoordinate, last))
                }
                
                return continuation.resume(returning: route)
            }
        }
    }
    
}
