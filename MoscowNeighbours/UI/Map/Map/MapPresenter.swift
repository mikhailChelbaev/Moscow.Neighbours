//
//  MapPresenter.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.12.2021.
//

import UIKit

protocol MapEventHandler: AnyObject {
    func onViewDidAppear()
}

class MapPresenter: MapEventHandler {
    
    // MARK: - Properties
    
    weak var viewController: MapView?
    
    private var routesBuilder: RoutesBuilder
    
    // MARK: - Init
    
    init(storage: MapStorage) {
        routesBuilder = storage.routesBuilder
    }
    
    // MARK: - MapEventHandler methods
    
    func onViewDidAppear() {
        let controller = routesBuilder.buildRouteViewController()
        viewController?.present(controller, state: .middle, completion: nil)
    }
    
}
