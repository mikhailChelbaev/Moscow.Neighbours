//
//  RoutesCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 17.04.2022.
//

import UIKit

public class RoutesCoordinator {
    public var controller: BottomSheetViewController?
    private let builder: Builder

    public init(builder: Builder) {
        self.builder = builder
    }
    
    public func start() {
        let storage = builder.makeRoutesStorage()
        controller = RoutesUIComposer.routesComposeWith(storage, coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
    
    public func displayRoute(route: Route) {
        let routeDescriptionCoordinator = RouteDescriptionCoordinator(route: route, builder: builder)
        routeDescriptionCoordinator.start()
        routeDescriptionCoordinator.present(on: controller, state: .top, completion: nil)
    }
}

