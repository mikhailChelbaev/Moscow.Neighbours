//
//  PersonBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import Foundation

public struct PersonStorage<Transformer: ItemTransformer> where Transformer.Input == PersonInfo, Transformer.Output == PersonViewModel {
    public let person: PersonInfo
    public let presentationState: PersonPresentationState
    let mapService: MapService
    public let personTransformer: Transformer
}

public final class PersonUIComposer {
    private init() {}
    
    public static func personComposeWith<Transformer: ItemTransformer>(storage: PersonStorage<Transformer>, coordinator: PersonCoordinator) -> PersonViewController where Transformer.Input == PersonInfo, Transformer.Output == PersonViewModel {
        let presenter = PersonPresenter(
            person: storage.person,
            personTransformer: TransformerMainQueueDispatchDecorator(decoratee: storage.personTransformer),
            presentationState: storage.presentationState,
            readyToGoButtonAction: { [weak coordinator] in
                coordinator?.dismiss(animated: true)
            })
        let tableViewController = PersonTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: { [weak coordinator] in
            coordinator?.dismiss(animated: true)
        })
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
