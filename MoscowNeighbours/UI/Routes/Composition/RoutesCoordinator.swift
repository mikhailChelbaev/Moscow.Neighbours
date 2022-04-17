//
//  RoutesCoordinator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 17.04.2022.
//

import UIKit

public class RoutesCoordinator {
    public private(set) var controller: RouteViewController?
    private let builder: Builder

    public init(builder: Builder) {
        self.builder = builder
    }
    
    public func start() {
        let storage = builder.makeRoutesStorage()
        controller = RoutesUIComposer.routesComposeWith(storage, coordinator: self)
    }
    
    public func present(on view: UIViewController?, state: BottomSheet.State, animated: Bool, completion: Action?) {
        guard let view = view, let controller = controller else { return }
        view.present(controller, state: state, completion: completion)
    }
}

