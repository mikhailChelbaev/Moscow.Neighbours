//
//  WeakRef+Map.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.12.2021.
//

import Foundation
import MapKit

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
