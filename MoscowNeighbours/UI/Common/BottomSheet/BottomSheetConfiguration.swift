//
//  BottomSheetConfiguration.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 22.12.2021.
//

import UIKit
import UltraDrawerView

public struct BottomSheetConfiguration {
    public var topInset: BottomSheet.RelativePosition
    public var middleInset: BottomSheet.RelativePosition
    public var availableStates: Set<BottomSheet.State>
    public var cornerRadius: CGFloat
    public var shadowRadius: CGFloat
    public var shadowOpacity: Float
    public var shadowOffset: CGSize
    
    public init(topInset: BottomSheet.RelativePosition = .fromTop(36),
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
