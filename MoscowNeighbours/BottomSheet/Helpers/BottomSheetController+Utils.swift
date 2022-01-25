//
//  BottomSheetController+Utils.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import UIKit
import UltraDrawerView

// MARK: - Bottom Sheet Dismiss

extension BottomSheetViewController {    
    func closeController(animated flag: Bool,
                            completion: (() -> Void)? = nil) {
        let states = bottomSheet.availableStates
        bottomSheet.availableStates = states.union([.dismissed])
        
        // show parent's bottom sheet
        if let parent = presentingViewController as? BottomSheetViewController {
            parent.viewWillAppear(true)
            parent.show(state: presentingControllerState, animated: true) { _ in
                parent.viewDidAppear(true)
            }
        }
        
        // hide bottom sheet and dismiss controller
        viewWillDisappear(true)
        bottomSheet.setState(.dismissed, animated: flag) { _ in
            self.dismiss(animated: false) {
                self.bottomSheet.availableStates = states
                self.viewDidAppear(true)
                completion?()
            }
        }
    }
}

// MARK: - Bottom Sheet Hide

extension BottomSheetViewController {
    func hide(animated flag: Bool, completion: ((Bool) -> Void)?) {
        let states = bottomSheet.availableStates
        
        bottomSheet.availableStates = states.union([.dismissed])
        bottomSheet.setState(.dismissed, animated: flag, completion: completion)
    }
}

// MARK: - Bottom Sheet Show

extension BottomSheetViewController {
    func show(state: BottomSheet.State,
              animated flag: Bool,
              completion: ((Bool) -> Void)? = nil) {
        bottomSheet.setState(state, animated: flag) { _ in
            let states = self.bottomSheet.availableStates
            self.bottomSheet.availableStates = states.subtracting([.dismissed])
            completion?(true)
        }
    }
}
