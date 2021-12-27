//
//  WeakRef+RoutePassing.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import Foundation

extension WeakRef: RoutePassingServiceOutput where T: RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonViewModel]) {
        object?.didVisitNewPersons(persons)
    }
    
    func updatePersons(_ persons: [PersonViewModel]) {
        object?.updatePersons(persons)
    }
    
    func onNotificationTap(_ person: PersonViewModel) {
        object?.onNotificationTap(person)
    }
}
