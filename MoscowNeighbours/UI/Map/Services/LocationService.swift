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
    
    func didChangeAuthorization()
}

// MARK: - LocationService

final class LocationService: NSObject {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.activityType = .fitness
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    private var isUpdateRequested: Bool = false
    
    private var monitoringRegions: [CLRegion] = []
    
    private var currentRegions: [CLRegion] = []
    
    private var isMonitoringRegions: Bool = false
    
    var currentLocation: CLLocation? {
        locationManager.location
    }
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocationUpdate() {
        if isMonitoringRegions, let location = locationManager.location {
            delegate?.didUpdateLocation(location: location)
        } else {
            isUpdateRequested = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func startMonitoring(for regions: [CLRegion]) {
        guard !regions.isEmpty else { return }
        monitoringRegions = regions
        updateCurrentRegions()
        locationManager.startUpdatingLocation()
        isMonitoringRegions = true
    }
    
    func stopMonitoring() {
        monitoringRegions = []
        currentRegions = []
        locationManager.stopUpdatingLocation()
        isMonitoringRegions = false
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.didChangeAuthorization()
    }
    
}

// MARK: - regions handle

extension LocationService {
    
    private func updateCurrentRegions() {
        guard let location = locationManager.location else { return }
        let regions = findRegions(for: location)
        var newRegions: [CLRegion] = []
        
        let difference = regions.difference(from: currentRegions)
        
        guard !difference.isEmpty else { return }
        
        difference.forEach { change in
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
