//
//  BottomSheetsManager.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit
import UltraDrawerView

class BottomSheetsManager {
    
    private var controllers: [BottomSheetViewController] = []
    
    private weak var presenter: UIViewController?
    
    private var states: [BottomSheetViewController: Set<DrawerView.State>] = [:]
    
    private var stack: Stack = Stack<(BottomSheetViewController, DrawerView.State)>()
    
    var currentController: BottomSheetViewController?
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func removeControllers() {
        controllers = []
    }
    
    func addController(
        _ controller: BottomSheetViewController,
        availableStates: Set<DrawerView.State> = [.top, .bottom, .middle]
    ) {
        if let index = controllers.firstIndex(where: { $0 == controller }) {
            controllers.insert(controller, at: index)
        } else {
            controllers.append(controller)
        }
        states[controller] = availableStates
    }
    
    func show(
        _ controller: BottomSheetViewController,
        state: DrawerView.State,
        animated: Bool = true
    ) {
        guard let presenter = presenter else { return }
        
        if let currentController = currentController {
            stack.push(item: (currentController, currentController.drawerView.state ?? .top))
        }
        controllers.forEach({
            if $0 != controller {
                $0.drawerView.availableStates = [.dismissed]
                $0.drawerView.setState(.dismissed, animated: animated)
            }
        })
        presenter.view.bringSubviewToFront(controller.view)
        controller.drawerView.availableStates = states[controller] ?? []
        controller.drawerView.setState(state, animated: animated)
        
        currentController = controller
    }
    
    func closeCurrent() {
        currentController = nil
        let (previousController, state) = stack.pop()
        show(previousController, state: state)
    }
    
}
