//
//  BottomSheetContentView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import UIKit
import UltraDrawerView

class BottomSheetContentView: UIView {
    weak var touchDelegate: UIView?
    weak var bottomSheet: BottomSheet?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bottomSheet?.point(inside: point, with: event) ?? false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {
            return touchDelegate?.hitTest(point, with: event)
        }
        
        return view
    }
}
