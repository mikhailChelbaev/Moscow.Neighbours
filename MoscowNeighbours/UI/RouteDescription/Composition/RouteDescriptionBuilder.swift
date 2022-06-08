//
//  RouteDescriptionBuilder.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import Foundation

public struct RouteDescriptionStorage {
    let model: Route
    let markdownTransformer: MarkdownTransformer
    let mapService: MapService
    let purchaseService: PurchaseRouteProvider
    
    public init(model: Route, markdownTransformer: MarkdownTransformer, mapService: MapService, purchaseService: PurchaseRouteProvider) {
        self.model = model
        self.markdownTransformer = markdownTransformer
        self.mapService = mapService
        self.purchaseService = purchaseService
    }
}

public final class RoutesDescriptionUIComposer {
    private init() {}
    
    public static func routeDescriptionComposeWith(
        storage: RouteDescriptionStorage,
        coordinator: RouteDescriptionCoordinator,
        mapService: MapService
    ) -> RouteDescriptionViewController {
        let closeCompletion: Action? = { [weak coordinator] in
            storage.mapService.hideRoute()
            coordinator?.dismiss(animated: true, completion: nil)
        }
        
        let presenter = RouteDescriptionPresenter(
            model: storage.model,
            markdownTransformer: MainQueueDispatchDecorator(decoratee: storage.markdownTransformer))
        let tableViewController = RouteDescriptionTableViewController()
        let backButtonController = BackButtonViewController(onBackButtonTap: closeCompletion)
        let controller = RouteDescriptionViewController(
            presenter: presenter,
            coordinator: coordinator,
            tableViewController: tableViewController,
            backButtonController: backButtonController,
            didShowRoute: {
                storage.mapService.showRoute(storage.model.personsInfo)
            })
        
        presenter.routeDescriptionView = RouteDescriptionViewAdapter(
            controller: tableViewController,
            coordinator: coordinator,
            purchaseService: MainQueueDispatchDecorator(decoratee: storage.purchaseService),
            purchaseErrorView: PurchaseErrorViewAdapter(coordinator: coordinator),
            onPersonCellTapAction: { [weak coordinator, weak mapService] personInfo in
                mapService?.selectAnnotation(personInfo)
                mapService?.centerAnnotation(personInfo)
                coordinator?.displayPerson(personInfo)
            })
        presenter.routeDescriptionLoadingView = WeakRef(tableViewController)
        
        return controller
    }
}
