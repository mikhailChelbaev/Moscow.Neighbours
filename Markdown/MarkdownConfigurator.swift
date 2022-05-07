//
//  MarkdownConfigurator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.10.2021.
//

import UIKit

public struct MarkdownConfigurator {
    public var fontSize: CGFloat
    public var headerSize: CGFloat
    public var subHeaderSize: CGFloat
    public var subSubHeaderSize: CGFloat
    
    public var textColor: UIColor
    public var lineHeightMultiple: Double
    
    public init(fontSize: CGFloat, headerSize: CGFloat, subHeaderSize: CGFloat, subSubHeaderSize: CGFloat, textColor: UIColor, lineHeightMultiple: Double) {
        self.fontSize = fontSize
        self.headerSize = headerSize
        self.subHeaderSize = subHeaderSize
        self.subSubHeaderSize = subSubHeaderSize
        self.textColor = textColor
        self.lineHeightMultiple = lineHeightMultiple
    }
}

extension MarkdownConfigurator {
    
    public static var `default`: MarkdownConfigurator = .init(fontSize: 18, headerSize: 24, subHeaderSize: 22, subSubHeaderSize: 20, textColor: .darkGray, lineHeightMultiple: 1.11)
    
}
