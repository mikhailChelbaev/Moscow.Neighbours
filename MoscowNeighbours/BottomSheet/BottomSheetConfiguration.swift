//
//  BottomSheetConfiguration.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import UIKit
import UltraDrawerView

struct BottomSheetConfiguration {
    var topInset: BottomSheet.RelativePosition
    var middleInset: BottomSheet.RelativePosition
    var availableStates: Set<BottomSheet.State>
    var cornerRadius: CGFloat
    var shadowRadius: CGFloat
    var shadowOpacity: Float
    var shadowOffset: CGSize
    
    init(topInset: BottomSheet.RelativePosition = .fromTop(36),
         middleInset: BottomSheet.RelativePosition = .fromBottom(280),
         availableStates: Set<BottomSheet.State> = [.top, .middle, .bottom],
         cornerRadius: CGFloat = 16,
         shadowRadius: CGFloat = 4,
         shadowOpacity: Float = 0.2,
         shadowOffset: CGSize = .zero) {
        self.topInset = topInset
        self.middleInset = middleInset
        self.availableStates = availableStates
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
    }
}
