//
//  PersonPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit

protocol PersonLoadingView {
    func display(isLoading: Bool)
}

protocol PersonView {
    func display(_ viewModel: PersonTableViewModel)
}

final class PersonPresenter<Transformer: ItemTransformer> where Transformer.Input == PersonInfo, Transformer.Output == PersonViewModel {
    
    private let person: PersonInfo
    private let personTransformer: Transformer
    private let presentationState: PersonPresentationState
    private let readyToGoButtonAction: Action?
    
    init(person: PersonInfo,
         personTransformer: Transformer,
         presentationState: PersonPresentationState,
         readyToGoButtonAction: Action?) {
        self.person = person
        self.personTransformer = personTransformer
        self.presentationState = presentationState
        self.readyToGoButtonAction = readyToGoButtonAction
    }
    
    var personView: PersonView?
    var personLoadingView: PersonLoadingView?
    
    private static var descriptionHeader: String {
        return "person.information".localized
    }
    private static var alertText: String {
        return "person.pass_route_alert".localized
    }
    private static var readyToGoButtonTitle: String {
        return "person.ready_to_go".localized
    }
    
}

extension PersonPresenter: PersonInput {
    
    func didTransformPerson() {
        personLoadingView?.display(isLoading: true)
        personTransformer.transform(person) { [weak self] personViewModel in
            self?.personLoadingView?.display(isLoading: false)
            
            let isFullDescription = self?.presentationState == .fullDescription
            let description = isFullDescription ? personViewModel.fullDescription : personViewModel.shortDescription
            let alert = isFullDescription ? nil : (PersonPresenter.alertText, AlertImage.exclamationMark)
            let button = isFullDescription ? (PersonPresenter.readyToGoButtonTitle, self?.readyToGoButtonAction) : nil
            self?.personView?.display(PersonTableViewModel(
                name: personViewModel.name,
                avatarURL: personViewModel.avatarUrl,
                descriptionHeader: PersonPresenter.descriptionHeader,
                description: description,
                information: personViewModel.info,
                showInformationInContainer: isFullDescription,
                showInformationBeforeDescription: isFullDescription,
                showInformationSeparator: !isFullDescription,
                showDescriptionSeparator: !isFullDescription,
                alert: alert,
                button: button))
        }
    }
    
}
