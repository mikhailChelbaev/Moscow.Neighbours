//
//  MarkdownConfigurator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.10.2021.
//

import UIKit

struct MarkdownConfigurator {
    var fontSize: CGFloat
    var headerSize: CGFloat
    var subHeaderSize: CGFloat
    var subSubHeaderSize: CGFloat
    
    var textColor: UIColor
    var lineHeightMultiple: Double
    
    init(fontSize: CGFloat, headerSize: CGFloat, subHeaderSize: CGFloat, subSubHeaderSize: CGFloat, textColor: UIColor, lineHeightMultiple: Double) {
        self.fontSize = fontSize
        self.headerSize = headerSize
        self.subHeaderSize = subHeaderSize
        self.subSubHeaderSize = subSubHeaderSize
        self.textColor = textColor
        self.lineHeightMultiple = lineHeightMultiple
    }
}

extension MarkdownConfigurator {
    
    static var `default`: MarkdownConfigurator = .init(fontSize: 18, headerSize: 24, subHeaderSize: 22, subSubHeaderSize: 20, textColor: .darkGray, lineHeightMultiple: 1.11)
    
}
