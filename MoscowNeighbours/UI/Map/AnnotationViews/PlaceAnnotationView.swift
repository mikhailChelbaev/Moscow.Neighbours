//
//  PlaceAnnotationView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 31.07.2021.
//

import MapKit

class PlaceAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - init
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = String(describing: PlaceClusterView.self)
        markerTintColor = .systemBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
