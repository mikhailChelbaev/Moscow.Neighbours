//
//  MapService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation

protocol MapServiceOutput {
    
}

class MapService {
    
    private let routeFinder: RouteFinder
    
    init(routeFinder: RouteFinder) {
        self.routeFinder = routeFinder
    }
    
    func showRoute(_ route: Route) {
            // add annotations
    //        mapView.addAnnotations(route.personsInfo)
            // draw route overlay
    //        drawRoute(annotations: route.personsInfo, withUserLocation: false)
    }
    
    func hideRoute() {
        // remove annotations
//        let annotations = mapView.annotations
//        mapView.removeAnnotations(annotations)
        
        // remove overlays
//        let overlays = mapView.overlays
//        mapView.removeOverlays(overlays)
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
//    private func drawRoute(annotations: [MKAnnotation], withUserLocation: Bool) {
//        var coordinates: [CLLocationCoordinate2D] = annotations.map({ $0.coordinate })
//
//        guard coordinates.count > 0 else { return }
//
//        var nearestCoordinate: CLLocationCoordinate2D?
//        if let currentLocation = locationService.currentLocation?.coordinate {
//            nearestCoordinate = routeOptimizer.findNearestCoordinate(from: currentLocation, coordinates: coordinates)
//        } else {
//            nearestCoordinate = coordinates.removeFirst()
//        }
//
//        guard let nearestCoordinate = nearestCoordinate else { return }
//
//        routeOptimizer.findRoute(from: nearestCoordinate, coordinates: coordinates) { [weak self] route in
//            let group = DispatchGroup()
//            var routes: [MKRoute?] = []
//            for points in route {
//                group.enter()
//                self?.findRoute(p1: points.p1, p2: points.p2) { route in
//                    routes.append(route)
//                    group.leave()
//                }
//            }
//            if withUserLocation {
//                if let p1 = self?.locationService.currentLocation?.coordinate, let p2 = route.first?.p1 {
//                    group.enter()
//                    self?.findRoute(p1: p1, p2: p2) { route in
//                        routes.append(route)
//                        group.leave()
//                    }
//                }
//            }
//            group.notify(queue: .main) {
//                if routes.contains(nil) {
//                    // TODO: - show error
//                    Logger.log("Failed to load full route")
//                } else {
//                    routes.compactMap(\.?.polyline).forEach { polyline in
//                        self?.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
//                    }
//                }
//            }
//        }
//
//        var allAnnotations: [MKAnnotation] = annotations
//        if withUserLocation {
//            allAnnotations.append(mapView.userLocation)
//        }
//
//        zoomAnnotations(allAnnotations)
//    }
//
//    private func findRoute(
//        p1: CLLocationCoordinate2D?,
//        p2: CLLocationCoordinate2D?,
//        completion: @escaping (MKRoute?) -> Void
//    ) {
//        guard let p1 = p1, let p2 = p2 else {
//            completion(nil)
//            return
//        }
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = .init(placemark: .init(coordinate: p1))
//        directionRequest.destination = .init(placemark: .init(coordinate: p2))
//        directionRequest.transportType = .walking
//                
//        let direction = MKDirections(request: directionRequest)
//        direction.calculate { (response, error) in
//            guard let response = response else {
//                if let error = error {
//                    Logger.log(error.localizedDescription)
//                }
//                completion(nil)
//                return
//            }
//
//            completion(response.routes.first)
//        }
//    }
}
