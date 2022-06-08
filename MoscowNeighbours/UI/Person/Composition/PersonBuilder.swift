//
//  PersonBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

public struct PersonStorage {
    public let person: PersonInfo
    public let presentationState: PersonPresentationState
    let mapService: MapService
    public let markdownTransformer: MarkdownTransformer
}

public final class PersonUIComposer {
    private init() {}
    
    public static func personComposeWith(storage: PersonStorage, coordinator: PersonCoordinator) -> PersonViewController {
        let dismiss: Action = { [weak coordinator] in
            coordinator?.dismiss(animated: true, completion: {
                storage.mapService.deselectAnnotation(storage.person)
            })
        }
        let presenter = PersonPresenter(
            person: storage.person,
            markdownTransformer: MainQueueDispatchDecorator(decoratee: storage.markdownTransformer),
            presentationState: storage.presentationState,
            readyToGoButtonAction: dismiss)
        let tableViewController = PersonTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: dismiss)
        let controller = PersonViewController(
            presenter: presenter,
            coordinator: coordinator,
            tableViewController: tableViewController,
            backButtonController: backButtonController)
        
        presenter.personView = PersonViewAdapter(controller: tableViewController)
        presenter.personLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
