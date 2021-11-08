//
//  LocationService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 01.11.2021.
//

import Foundation
import MapKit

// MARK: - LocationServiceDelegate

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(location: CLLocation)
    func didFailWithError(error: Error)
    
    func didUpdateCurrentRegions(_ regions: [CLRegion])
    func didEnterNewRegions(_ regions: [CLRegion])
}

// MARK: - LocationService

final class LocationService: NSObject {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.activityType = .fitness
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    private var isUpdateRequested: Bool = false
    
    private var monitoringRegions: [CLRegion] = []
    
    private var currentRegions: [CLRegion] = []
    
    var currentLocation: CLLocation? {
        locationManager.location
    }
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    func requestLocationUpdate() {
        isUpdateRequested = true
        locationManager.startUpdatingLocation()
    }
    
    func startMonitoring(for regions: [CLRegion]) {
        monitoringRegions = regions
        updateCurrentRegions()
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoring() {
        monitoringRegions = []
        currentRegions = []
        locationManager.stopUpdatingLocation()
    }
    
}

// MARK: - extension CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if isUpdateRequested {
            delegate?.didUpdateLocation(location: location)
            isUpdateRequested = false
        }
        
        guard !monitoringRegions.isEmpty else {
            locationManager.stopUpdatingLocation()
            return
        }
        
        updateCurrentRegions()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if isUpdateRequested {
            delegate?.didFailWithError(error: error)
            isUpdateRequested = false
        }
        if monitoringRegions.isEmpty {
            locationManager.stopUpdatingLocation()
        }
    }
    
}

// MARK: - regions handle

extension LocationService {
    
    private func updateCurrentRegions() {
        guard let location = locationManager.location else { return }
        let regions = findRegions(for: location)
        var newRegions: [CLRegion] = []
        
        regions.difference(from: currentRegions).forEach { change in
            if case .insert(offset: _, element: let region, associatedWith: _) = change {
                newRegions.append(region)
            }
        }
        
        delegate?.didUpdateCurrentRegions(regions)
        delegate?.didEnterNewRegions(newRegions)
        
        currentRegions = regions
    }
    
    private func findRegions(for location: CLLocation) -> [CLRegion] {
        monitoringRegions.filter({ ($0 as? CLCircularRegion)?.contains(location.coordinate) == true })
    }
    
}
