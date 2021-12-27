//
//  RoutePassingService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import Foundation
import MapKit

protocol RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonViewModel])
    func updatePersons(_ persons: [PersonViewModel])
    func onNotificationTap(_ person: PersonViewModel)
}

class RoutePassingService: ObservableService {
    
    var observers: [String : RoutePassingServiceOutput] = [:]
    
    private var locationService: LocationService
    private let notificationService: NotificationService
    
    private var currentRoute: RouteViewModel?
    
    var isPassingRoute: Bool {
        return currentRoute != nil
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
    
    func startRoute(_ route: RouteViewModel) {
        currentRoute = route
        let monitoringRegions: [CLCircularRegion] = route.persons.map({ person in
            let coordinate = person.coordinate
            let regionRadius: Double = 30
            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: person.id)
            return region
        })
        locationService.startMonitoring(for: monitoringRegions)
    }
    
    func stopRoute() {
        currentRoute = nil
        locationService.stopMonitoring()
    }
    
}

extension RoutePassingService: LocationServiceOutput {
    func didUpdateLocation(location: CLLocation) { }
    
    func didFailWithError(error: Error) { }
    
    func didChangeAuthorization() { }
    
    func didUpdateCurrentRegions(_ regions: [CLRegion]) {
        let persons = findPersonsForRegions(regions)
        observers.forEach({ $1.updatePersons(persons) })
    }
    
    func didEnterNewRegions(_ regions: [CLRegion]) {
        let persons = findPersonsForRegions(regions)
        observers.forEach({ $1.didVisitNewPersons(persons) })

        if let person = persons.first {
            notificationService.fireNotification(title: person.name) { [weak self] in
                self?.observers.forEach({ $1.onNotificationTap(person) })
            }
        }
    }
    
    private func findPersonsForRegions(_ regions: [CLRegion]) -> [PersonViewModel] {
        let persons: [PersonViewModel] = regions.compactMap({ region in
            if let regionCenter = (region as? CLCircularRegion)?.center,
               let person = currentRoute?.persons.first(where: { $0.coordinate == regionCenter }) {
                return person
            }
            return nil
        })
        return persons
    }
}
