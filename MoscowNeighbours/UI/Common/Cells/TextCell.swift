//
//  TextCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

class TextCell: CellView {
    
    let label = UILabel()
    
    var labelConstraints: AnchoredConstraints?
    
    override func commonInit() {
        backgroundColor = .background
        
        addSubview(label)
        labelConstraints = label.stickToSuperviewEdges(.all, insets: .init(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    func update(
        text: String?,
        attributedText: NSAttributedString? = nil,
        font: UIFont? = .mainFont(ofSize: 17, weight: .regular),
        textColor: UIColor = .label,
        numberOfLines: Int = 0,
        insets: UIEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16),
        kern: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil
    ) {
        if let attributedText = attributedText {
            label.text = nil
            label.attributedText = attributedText
        } else {
            label.setAttributedText(text, kern: kern, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple)
        }
        if let font = font {
            label.font = font
        }
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        labelConstraints?.updateInsets(insets)
        
        self.backgroundColor = backgroundColor
    }
    
}
