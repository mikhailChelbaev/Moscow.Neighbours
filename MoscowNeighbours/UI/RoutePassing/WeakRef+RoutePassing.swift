//
//  WeakRef+RoutePassing.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import Foundation

extension WeakRef: RoutePassingServiceOutput where T: RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [LegacyPersonViewModel]) {
        object?.didVisitNewPersons(persons)
    }
    
    func updatePersons(_ persons: [LegacyPersonViewModel]) {
        object?.updatePersons(persons)
    }
    
    func onNotificationTap(_ person: LegacyPersonViewModel) {
        object?.onNotificationTap(person)
    }
}
