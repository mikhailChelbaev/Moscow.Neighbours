//
//  RouteDescriptionCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import UIKit

public class RouteDescriptionCoordinator {
    private let builder: Builder
    private let route: Route
    
    public init(route: Route, builder: Builder) {
        self.builder = builder
        self.route = route
    }
    
    public var controller: BottomSheetViewController?
    
    public func start() {
        controller = RoutesDescriptionUIComposer.routeDescriptionComposeWith(
            storage: RouteDescriptionStorage(
                model: route,
                routeTransformer: RouteTransformer()),
            coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
    
    public func dismiss(animated: Bool, completion: Action? = nil) {
        controller?.closeController(animated: animated, completion: completion)
        controller = nil
    }
    
    public func displayPerson(_ personInfo: PersonInfo) {
        
    }
}
