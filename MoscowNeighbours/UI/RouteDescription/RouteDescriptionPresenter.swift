//
//  RouteDescriptionPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.12.2021.
//

import Foundation

protocol RouteDescriptionEventHandler: AnyObject {
    func getRoute() -> RouteViewModel
    func onTraitCollectionDidChange()
    func onBackButtonTap()
    func onPersonCellTap(personInfo: PersonInfo)
    func onBeginRouteButtonTap()
}

class RouteDescriptionPresenter: RouteDescriptionEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: RouteDescriptionView?
    
    private let personBuilder: PersonBuilder
    private let routePassingBuilder: RoutePassingBuilder
    
    private let route: Route
    private var routeViewModel: RouteViewModel
    
    private let mapService: MapService
    
    // MARK: - Init
    
    init(storage: RouteDescriptionStorage) {
        route = storage.route
        routeViewModel = RouteViewModel(from: route)
        
        personBuilder = storage.personBuilder
        routePassingBuilder = storage.routePassingBuilder
        
        mapService = storage.mapService
        
        mapService.showRoute(route)
    }
    
    // MARK: - RouteDescriptionEventHandler methods
    
    func getRoute() -> RouteViewModel {
        return routeViewModel
    }
    
    func onTraitCollectionDidChange() {
        routeViewModel.update()
        viewController?.reloadData()
    }
    
    func onBackButtonTap() {
        mapService.hideRoute()
        viewController?.closeController(animated: true, completion: nil)
    }
    
    func onPersonCellTap(personInfo: PersonInfo) {
        let controller = personBuilder.buildPersonViewController(personInfo: personInfo, userState: .default)
        viewController?.present(controller, state: .top)
    }
    
    func onBeginRouteButtonTap() {
        let controller = routePassingBuilder.buildRoutePassingViewController(route: routeViewModel)
        viewController?.present(controller, state: .top, completion: nil)
    }
    
}
