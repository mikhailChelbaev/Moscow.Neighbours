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
    private let route: Route
    
    // MARK: - Init
    
    init(storage: RouteDescriptionStorage) {
        route = storage.route
        personBuilder = storage.personBuilder
    }
    
    // MARK: - RouteDescriptionEventHandler methods
    
    func getRoute() -> RouteViewModel {
        return RouteViewModel(from: route)
    }
    
    func onTraitCollectionDidChange() {
        viewController?.route.update()
        viewController?.reloadData()
    }
    
    func onBackButtonTap() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func onPersonCellTap(personInfo: PersonInfo) {
        let controller = personBuilder.buildPersonViewController(personInfo: personInfo, userState: .default)
        viewController?.present(controller, state: .top)
    }
    
    func onBeginRouteButtonTap() {
        
    }
    
}
