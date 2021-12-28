//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.12.2021.
//

import Foundation

protocol RouteDescriptionEventHandler: AnyObject {
    func onViewDidLoad()
    func onTraitCollectionDidChange(route: RouteViewModel?)
    func onBackButtonTap()
    func onPersonCellTap(person: PersonViewModel)
    func onBeginRouteButtonTap(route: RouteViewModel?)
}

class RouteDescriptionPresenter: RouteDescriptionEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RouteDescriptionView?
    
    private let personBuilder: PersonBuilder
    private let routePassingBuilder: RoutePassingBuilder
    
    private var route: Route
    
    private let mapService: MapService
    
    private let minimumFetchingDuration: TimeInterval = 1.0
    private var startFetchingDate: Date = .init()
    
    // MARK: - Init
    
    init(storage: RouteDescriptionStorage) {
        personBuilder = storage.personBuilder
        routePassingBuilder = storage.routePassingBuilder
        
        mapService = storage.mapService
        
        route = storage.route
    }
    
    // MARK: - RouteDescriptionEventHandler methods
    
    func onViewDidLoad() {
        Task {
            viewController?.status = .loading
            let routeViewModel = await RouteViewModel(from: route)
            await setRoute(routeViewModel)
            await mapService.showRoute(routeViewModel)
        }
    }
    
    @MainActor
    private func setRoute(_ route: RouteViewModel) {
        completeWithDelay {
            self.viewController?.route = route
            self.viewController?.status = .success
        }
    }
    
    func onTraitCollectionDidChange(route: RouteViewModel?) {
        guard let route = route else {
            return
        }
        
        viewController?.status = .loading
        Task.detached { [weak self] in
            await route.update()
            await self?.setUpdatedRoute(route)
            await self?.mapService.showRoute(route)
        }
    }
    
    @MainActor
    private func setUpdatedRoute(_ route: RouteViewModel?) {
        viewController?.route = route
        viewController?.status = .success
        viewController?.reloadData()
    }
    
    func onBackButtonTap() {
        mapService.hideRoute()
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onPersonCellTap(person: PersonViewModel) {
        mapService.selectAnnotation(person)
        mapService.centerAnnotation(person)
        let controller = personBuilder.buildPersonViewController(person: person,
                                                                 personPresentationState: .shortDescription)
        viewController?.present(controller, state: .top)
    }
    
    func onBeginRouteButtonTap(route: RouteViewModel?) {
        guard let route = route else {
            return
        }

        let controller = routePassingBuilder.buildRoutePassingViewController(route: route)
        viewController?.present(controller, state: .middle, completion: nil)
    }
    
    private func completeWithDelay(_ completion: Action?) {
        let delay: TimeInterval = max(0, minimumFetchingDuration - Date().timeIntervalSince(startFetchingDate))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion?()
        }
    }    
}
