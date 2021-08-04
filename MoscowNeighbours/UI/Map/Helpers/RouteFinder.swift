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
    
    func findRoute(from coordinate: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D], completion: @escaping (RouteCoordinates) -> Void)
}

extension RouteFinder {
    
    func findNearestCoordinate(from coordinate: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
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
    
    func calculateCoordinatesDistance(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> Double {
        sqrt(pow(p1.latitude - p2.latitude, 2) + pow(p1.longitude - p2.longitude, 2))
    }
    
}

class NearestCoordinatesFinder: RouteFinder {
    
    private let queue = DispatchQueue(label: "NearestCoordinatesFinder", qos: .background)
    
    func findRoute(from coordinate: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D], completion: @escaping (RouteCoordinates) -> Void) {
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
            
            DispatchQueue.main.async {
                completion(route)
            }
        }
    }
    
}
