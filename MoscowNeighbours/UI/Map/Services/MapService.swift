//
//  MapService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation
import MapKit

protocol MapServiceOutput {
    func showAnnotations(_ annotations: [MKAnnotation])
    @MainActor func addOverlays(_ overlays: [MKOverlay])
    func removeAnnotations(_ annotations: [MKAnnotation])
    func removeOverlays(_ overlays: [MKOverlay])
}

class MapService: ObservableService {
    
    private let routeFinder: RouteFinder
    private let locationService: LocationService
    
    private var annotations: [MKAnnotation] = []
    private var overlays: [MKOverlay] = []
    
    var observers: [String : MapServiceOutput] = [:]
    
    init(routeFinder: RouteFinder,
         locationService: LocationService) {
        self.routeFinder = routeFinder
        self.locationService = locationService
    }
    
    func showRoute(_ route: Route) {
        // add annotations
        annotations = route.personsInfo
        observers.forEach({ $1.showAnnotations(annotations) })
        // draw route overlay
        Task {
            overlays = await getOverlays(annotations: annotations)
            for observer in observers {
                await observer.value.addOverlays(overlays)
            }
        }
    }
    
    func hideRoute() {
        // remove annotations
        observers.forEach({ $0.value.removeAnnotations(annotations) })
        annotations = []
        
        // remove overlays
        observers.forEach({ $0.value.removeOverlays(overlays) })
        overlays = []
    }
    
    func startRoutePassing(_ route: Route) {
        // create Regions
//        createRegions(for: currentlySelectedRoute)
    }
    
    func stopRoutePassing() {
        // remove regions
        removeRegions()
    }
    
    private func createRegions(for route: Route?) {
//        guard let route = route else { return }
//        monitoringRegions = route.personsInfo.map({ info in
//            let coordinate = info.coordinate
//            let regionRadius: Double = 30
//            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: info.id)
//            return region
//        })
//        locationService.startMonitoring(for: monitoringRegions)
    }
    
    private func removeRegions() {
//        locationService.stopMonitoring()
//        monitoringRegions = []
//        visitedPersons = []
//        viewedPersons = []
    }
    
}

extension MapService {
    private func getOverlays(annotations: [MKAnnotation]) async -> [MKOverlay] {
        var coordinates: [CLLocationCoordinate2D] = annotations.map({ $0.coordinate })

        guard coordinates.count > 0 else { return [] }

        var nearestCoordinate: CLLocationCoordinate2D?
        if let currentLocation = locationService.currentLocation?.coordinate {
            nearestCoordinate = routeFinder.findNearestCoordinate(from: currentLocation, coordinates: coordinates)
        } else {
            nearestCoordinate = coordinates.removeFirst()
        }

        guard let nearestCoordinate = nearestCoordinate else { return [] }

        let route = await routeFinder.findRoute(from: nearestCoordinate, coordinates: coordinates)
        
        let overlays = try? await withThrowingTaskGroup(of: MKRoute?.self,
                                           returning: [MKOverlay].self,
                                           body: { group in
            for points in route {
                group.addTask(priority: .utility) {
                    return await self.findRoutePart(p1: points.p1, p2: points.p2)
                }
            }
            
            var routes: [MKRoute?] = []
            for try await route in group {
                routes.append(route)
            }
            
            if routes.contains(nil) {
                // TODO: - throw error
                Logger.log("Failed to load full route")
                return []
            } else {
                return routes.compactMap(\.?.polyline)
            }
        })
        
        return overlays ?? []
    }

    private func findRoutePart(p1: CLLocationCoordinate2D?,
                           p2: CLLocationCoordinate2D?) async -> MKRoute? {
        guard let p1 = p1, let p2 = p2 else {
            return nil
        }
        let directionRequest = MKDirections.Request()
        directionRequest.source = .init(placemark: .init(coordinate: p1))
        directionRequest.destination = .init(placemark: .init(coordinate: p2))
        directionRequest.transportType = .walking
                
        let direction = MKDirections(request: directionRequest)
        let route: MKRoute? = await withCheckedContinuation { continuation in
            direction.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        Logger.log(error.localizedDescription)
                    }
                    return continuation.resume(returning: nil)
                }
                return continuation.resume(returning: response.routes.first)
            }
        }
        return route
    }
}
