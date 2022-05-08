//
//  UIViewController+PresentBS.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import UIKit
import UltraDrawerView

extension UIViewController {
    func present(_ viewControllerToPresent: BottomSheetViewController,
                 state: DrawerView.State,
                 completion: (() -> Void)? = nil) {
        let states = viewControllerToPresent.bottomSheet.availableStates
        
        viewControllerToPresent.bottomSheet.availableStates = states.union([.dismissed])
        viewControllerToPresent.bottomSheet.setState(.dismissed, animated: false)
        
        // hide parent's bottom sheet
        if let parent = self as? BottomSheetViewController,
            let state = parent.bottomSheet.state {
            viewControllerToPresent.presentingControllerState = state
            parent.viewWillDisappear(true)
            parent.hide(animated: true) { _ in
                parent.viewDidDisappear(true)
            }
        }
        
        viewControllerToPresent.viewWillAppear(true)
        present(viewControllerToPresent, animated: false) {
            // show bottom sheet
            viewControllerToPresent.bottomSheet.setState(state, animated: true)
            viewControllerToPresent.bottomSheet.availableStates = states
            
            viewControllerToPresent.viewDidAppear(true)
            
            completion?()
        }
    }
}
