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
    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        let states = bottomSheet.availableStates
        bottomSheet.availableStates = states.union([.dismissed])
        
        // show parent's bottom sheet
        if let parent = presentingViewController as? BottomSheetViewController {
            parent.show(state: presentingControllerState, animated: true)
        }
        
        // hide bottom sheet and dismiss controller
        bottomSheet.setState(.dismissed, animated: flag) { _ in
            super.dismiss(animated: false) {
                self.bottomSheet.availableStates = states
                completion?()
            }
        }
    }
}

// MARK: - Bottom Sheet Hide

extension BottomSheetViewController {
    func hide(animated flag: Bool) {
        let states = bottomSheet.availableStates
        
        bottomSheet.availableStates = states.union([.dismissed])
        bottomSheet.setState(.dismissed, animated: flag)
    }
}

// MARK: - Bottom Sheet Show

extension BottomSheetViewController {
    func show(state: BottomSheet.State,
              animated flag: Bool) {
        bottomSheet.setState(state, animated: flag) { _ in
            let states = self.bottomSheet.availableStates
            self.bottomSheet.availableStates = states.subtracting([.dismissed])
        }
    }
}
