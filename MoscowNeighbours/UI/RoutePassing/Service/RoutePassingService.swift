//
//  RoutePassingService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import Foundation
import MapKit

protocol RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonInfo])
    func onNotificationTap(_ person: PersonInfo)
}

class RoutePassingService: ObservableService {
    
    var observers: [String : RoutePassingServiceOutput] = [:]
    
    private var locationService: LocationService
    private let notificationService: NotificationService
    
    private var currentPersons: [PersonInfo]?
    
    var isPassingRoute: Bool {
        return currentPersons != nil
    }
    
    init(locationService: LocationService,
         notificationService: NotificationService) {
        self.locationService = locationService
        self.notificationService = notificationService
        
        self.locationService.register(WeakRef(self))
    }
    
    func requestNotifications() {
        notificationService.requestAuthorization()
    }
    
    func startRoute(_ persons: [PersonInfo]) {
        currentPersons = persons
        let monitoringRegions: [CLCircularRegion] = persons.map({ person in
            let coordinate = person.coordinate
            let regionRadius: Double = 30
            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: person.id)
            return region
        })
        locationService.startMonitoring(for: monitoringRegions)
    }
    
    func stopRoute() {
        currentPersons = nil
        locationService.stopMonitoring()
    }
    
}

extension RoutePassingService: LocationServiceOutput {
    func didUpdateLocation(location: CLLocation) { }
    
    func didFailWithError(error: Error) { }
    
    func didChangeAuthorization() { }
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) {
//        let persons = findPersonsForRegions(regions)
//        observers.forEach({ $1.updatePersons(persons) })
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
        let persons = findPersonsForRegions(regions)
        observers.forEach({ $1.didVisitNewPersons(persons) })

        if let personInfo = persons.first {
            notificationService.fireNotification(title: personInfo.person.name) { [weak self] in
                self?.observers.forEach({ $1.onNotificationTap(personInfo) })
            }
        }
    }
    
    private func findPersonsForRegions(_ regions: [CLRegion]) -> [PersonInfo] {
        let persons: [PersonInfo] = regions.compactMap({ region in
            if let regionCenter = (region as? CLCircularRegion)?.center,
               let person = currentPersons?.first(where: { $0.coordinate == regionCenter }) {
                return person
            }
            return nil
        })
        return persons
    }
}
