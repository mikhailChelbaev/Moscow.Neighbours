//
//  AlertAction.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.05.2022.
//

import Foundation

public struct AlertAction {    
    public let title: String?
    public let style: ActionStyle
    public let completion: Action?
    
    public init(title: String?, style: ActionStyle, completion: Action? = nil) {
        self.title = title
        self.style = style
        self.completion = completion
    }
}

extension AlertAction: Equatable {
    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title && lhs.style == rhs.style
    }
}
