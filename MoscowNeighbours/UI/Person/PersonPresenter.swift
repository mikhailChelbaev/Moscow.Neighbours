//
//  PersonPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit

protocol PersonEventHandler {
    func getPersonInfo() -> LegacyPersonViewModel
    func onTraitCollectionDidChange()
    func getPersonPresentationState() -> PersonPresentationState
    func onBackButtonTap()
    func onPersonUpdate(person: LegacyPersonViewModel, personPresentationState: PersonPresentationState)
}

class PersonPresenter: PersonEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: PersonView?
    
    private var person: LegacyPersonViewModel
    private let personPresentationState: PersonPresentationState
    
    private let mapService: MapService
    
    // MARK: - Init
    
    init(storage: PersonStorage) {
        person = storage.person
        personPresentationState = storage.personPresentationState
        mapService = storage.mapService
    }
    
    // MARK: - PersonEventHandler methods
    
    func getPersonInfo() -> LegacyPersonViewModel {
        return person
    }
    
    func onTraitCollectionDidChange() {
        viewController?.status = .loading
        DispatchQueue.global(qos: .userInitiated).async {
            self.person.update()
            DispatchQueue.main.async {
                self.setUpdatedPerson(self.person)
            }
        }
    }
    
    private func setUpdatedPerson(_ person: LegacyPersonViewModel) {
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
    
    func onPersonUpdate(person: LegacyPersonViewModel, personPresentationState: PersonPresentationState) {
        self.person = person
        viewController?.person = person
        viewController?.personPresentationState = personPresentationState
        viewController?.reloadData()
    }
    
}
