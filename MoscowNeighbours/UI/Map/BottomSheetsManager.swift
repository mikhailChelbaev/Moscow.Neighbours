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
    
    init(controllers: [BottomSheetViewController] = [], presenter: UIViewController) {
        self.controllers = controllers
        self.presenter = presenter
    }
    
    func removeController() {
        controllers = []
    }
    
    func addController(_ controller: BottomSheetViewController) {
        controllers.append(controller)
    }
    
    func show(
        _ controller: BottomSheetViewController,
        state: DrawerView.State,
        states: Set<DrawerView.State> = [.top, .bottom, .middle]
    ) {
        guard let presenter = presenter else { return }
        controllers.forEach({
            if $0 != controller {
                $0.drawerView.availableStates = [.dismissed]
                $0.drawerView.setState(.dismissed, animated: true)
            }
        })
        presenter.view.bringSubviewToFront(controller.view)
        controller.drawerView.availableStates = states
        controller.drawerView.setState(state, animated: true)
    }
    
    
}
