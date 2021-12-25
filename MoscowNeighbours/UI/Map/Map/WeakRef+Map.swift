//
//  WeakRef+Map.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation
import MapKit

// MARK: - LocationServiceOutput

extension WeakRef: LocationServiceOutput where T: LocationServiceOutput {
    func didUpdateLocation(location: CLLocation) {
        object?.didUpdateLocation(location: location)
    }
    
    func didFailWithError(error: Error) {
        object?.didFailWithError(error: error)
    }
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) {
        object?.didUpdateCurrentRegions(regions)
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
        object?.didEnterNewRegions(regions)
    }
    
    func didChangeAuthorization() {
        object?.didChangeAuthorization()
    }
}

// MARK: - MapServiceOutput

extension WeakRef: MapServiceOutput where T: MapServiceOutput {
    func showAnnotations(_ annotations: [MKAnnotation]) {
        object?.showAnnotations(annotations)
    }
    
    func addOverlays(_ overlays: [MKOverlay]) {
        object?.addOverlays(overlays)
    }
    
    func removeAnnotations(_ annotations: [MKAnnotation]) {
        object?.removeAnnotations(annotations)
    }
    
    func removeOverlays(_ overlays: [MKOverlay]) {
        object?.removeOverlays(overlays)
    }
}
