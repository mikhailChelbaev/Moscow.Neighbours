//
//  MKMapView+Annotations.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.09.2021.
//

import Foundation
import MapKit

extension MKMapView {
    
    func removeAllAnnotations() {
        removeAnnotations(annotations)
    }
    
    func removeAllOverlays() {
        removeOverlays(overlays)
    }
    
}
