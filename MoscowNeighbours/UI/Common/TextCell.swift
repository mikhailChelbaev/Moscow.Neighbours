//
//  TextCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

final class TextCell: CellView {
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var labelConstraints: AnchoredConstraints?
    
    override func commonInit() {
        addSubview(label)
        labelConstraints = label.stickToSuperviewEdges(.all, insets: .init(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    func update(
        text: String?,
        attributedText: NSAttributedString? = nil,
        font: UIFont = .mainFont(ofSize: 17, weight: .regular),
        textColor: UIColor = .label,
        numberOfLines: Int = 0,
        backgroundColor: UIColor = .systemBackground,
        insets: UIEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
    ) {
        if let attributedText = attributedText {
            label.text = nil
            label.attributedText = attributedText
        } else {
            label.attributedText = nil
            label.text = text
        }
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        labelConstraints?.updateInsets(insets)
        
        self.backgroundColor = backgroundColor
    }
    
}
