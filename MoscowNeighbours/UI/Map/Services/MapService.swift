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
    func removeAnnotations(_ annotations: [MKAnnotation])
    
    @MainActor func addOverlays(_ overlays: [MKOverlay])
    func removeOverlays(_ overlays: [MKOverlay])
    
    func selectAnnotation(_ annotation: MKAnnotation)
    func deselectAnnotation(_ annotation: MKAnnotation)
    func centerAnnotation(_ annotation: MKAnnotation)
    
    func didSelectAnnotation(_ view: MKAnnotationView)
}

class MapService: ObservableService {
    
    private let routeFinder: RouteFinder
    private let locationService: LocationService
    
    private var annotations: [MKAnnotation] = []
    private var overlays: [MKOverlay] = []
    
    private var isRouteVisible: Bool = false
    
    var observers: [String : MapServiceOutput] = [:]
    
    init(routeFinder: RouteFinder,
         locationService: LocationService) {
        self.routeFinder = routeFinder
        self.locationService = locationService
    }
    
    @MainActor func showRoute(_ route: RouteViewModel) {
        isRouteVisible = true
        
        // clear map
        for observer in observers {
            observer.value.removeAnnotations(annotations)
            observer.value.removeOverlays(overlays)
        }
        // add annotations
        annotations = route.persons
        observers.forEach({ $1.showAnnotations(annotations) })
        // draw route overlay
        Task.detached { [weak self] in
            guard let self = self else { return }
            self.overlays = await self.getOverlays(annotations: self.annotations)
            
            // check that route was not hidden
            guard self.isRouteVisible else { return }
            
            for observer in self.observers {
                await observer.value.addOverlays(self.overlays)
            }
        }
    }
    
    func hideRoute() {
        isRouteVisible = false
        
        // remove annotations
        observers.forEach({ $0.value.removeAnnotations(annotations) })
        annotations = []
        
        // remove overlays
        observers.forEach({ $0.value.removeOverlays(overlays) })
        overlays = []
    }
    
    func selectAnnotation(_ annotation: MKAnnotation) {
        observers.forEach({ $0.value.selectAnnotation(annotation) })
    }
    
    func deselectAnnotation(_ annotation: MKAnnotation) {
        observers.forEach({ $0.value.deselectAnnotation(annotation) })
    }
    
    func centerAnnotation(_ annotation: MKAnnotation) {
        observers.forEach({ $0.value.centerAnnotation(annotation) })
    }
    
    func didSelectAnnotation(_ annotation: MKAnnotationView) {
        observers.forEach({ $0.value.didSelectAnnotation(annotation) })
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
