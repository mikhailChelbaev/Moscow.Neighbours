//
//  Builder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import Foundation

class Builder {
    let locationService: LocationService = .init()
    lazy var mapService: MapService = .init(routeFinder: NearestCoordinatesFinder(),
                                            locationService: locationService)
}
