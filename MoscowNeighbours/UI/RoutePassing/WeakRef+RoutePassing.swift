//
//  WeakRef+RoutePassing.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.12.2021.
//

import Foundation

extension WeakRef: RoutePassingServiceOutput where T: RoutePassingServiceOutput {
    func didVisitNewPersons(_ persons: [PersonInfo]) {
        object?.didVisitNewPersons(persons)
    }
    
    func onNotificationTap(_ person: PersonInfo) {
        object?.onNotificationTap(person)
    }
}
