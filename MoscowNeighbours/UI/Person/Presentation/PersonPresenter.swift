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

final class PersonPresenter {
    
    private let model: PersonInfo
    private let markdownTransformer: MarkdownTransformer
    private let presentationState: PersonPresentationState
    private let readyToGoButtonAction: Action?
    
    init(person: PersonInfo,
         markdownTransformer: MarkdownTransformer,
         presentationState: PersonPresentationState,
         readyToGoButtonAction: Action?) {
        self.model = person
        self.markdownTransformer = markdownTransformer
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
        
        let isFullDescription = presentationState == .fullDescription
        let description = isFullDescription ? model.person.description : model.person.shortDescription
        markdownTransformer.transform(description) { [weak self] description in
            self?.personLoadingView?.display(isLoading: false)
            
            guard let model = self?.model else { return }
            
            let alert = isFullDescription ? nil : (PersonPresenter.alertText, AlertImage.exclamationMark)
            let button = isFullDescription ? (PersonPresenter.readyToGoButtonTitle, self?.readyToGoButtonAction) : nil
            self?.personView?.display(PersonTableViewModel(
                name: model.person.name,
                avatarURL: model.person.avatarUrl,
                descriptionHeader: PersonPresenter.descriptionHeader,
                description: description,
                information: model.person.info,
                showInformationInContainer: isFullDescription,
                showInformationBeforeDescription: isFullDescription,
                showInformationSeparator: !isFullDescription,
                showDescriptionSeparator: !isFullDescription,
                alert: alert,
                button: button))
        }
    }
    
}
