//
//  PersonBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

struct PersonStorage {
    let person: LegacyPersonViewModel
    let personPresentationState: PersonPresentationState
    let mapService: MapService
}

protocol PersonBuilder {
    func buildPersonViewController(person: LegacyPersonViewModel,
                                   personPresentationState: PersonPresentationState) -> PersonViewController
}

extension Builder: PersonBuilder {
    func buildPersonViewController(person: LegacyPersonViewModel,
                                   personPresentationState: PersonPresentationState) -> PersonViewController {
        let storage = PersonStorage(person: person,
                                    personPresentationState: personPresentationState,
                                    mapService: mapService)
        let presenter = PersonPresenter(storage: storage)
        let viewController = PersonViewController(eventHandler: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
