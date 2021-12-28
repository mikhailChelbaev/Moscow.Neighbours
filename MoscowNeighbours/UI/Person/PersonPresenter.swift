//
//  PersonPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit

protocol PersonEventHandler {
    func getPersonInfo() -> PersonViewModel
    func onTraitCollectionDidChange()
    func getPersonPresentationState() -> PersonPresentationState
    func onBackButtonTap()
    func onPersonUpdate(person: PersonViewModel, personPresentationState: PersonPresentationState)
}

class PersonPresenter: PersonEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: PersonView?
    
    private var person: PersonViewModel
    private let personPresentationState: PersonPresentationState
    
    private let mapService: MapService
    
    // MARK: - Init
    
    init(storage: PersonStorage) {
        person = storage.person
        personPresentationState = storage.personPresentationState
        mapService = storage.mapService
    }
    
    // MARK: - PersonEventHandler methods
    
    func getPersonInfo() -> PersonViewModel {
        return person
    }
    
    func onTraitCollectionDidChange() {
        viewController?.status = .loading
        Task.detached { [weak self] in
            guard let self = self else { return }
            await self.person.update()
            await self.setUpdatedPerson(self.person)
        }
    }
    
    @MainActor
    private func setUpdatedPerson(_ person: PersonViewModel) {
        viewController?.person = person
        viewController?.status = .success
        viewController?.reloadData()
    }
    
    func getPersonPresentationState() -> PersonPresentationState {
        return personPresentationState
    }
    
    func onBackButtonTap() {
        mapService.deselectAnnotation(person)
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onPersonUpdate(person: PersonViewModel, personPresentationState: PersonPresentationState) {
        self.person = person
        viewController?.person = person
        viewController?.personPresentationState = personPresentationState
        viewController?.reloadData()
    }
    
}
