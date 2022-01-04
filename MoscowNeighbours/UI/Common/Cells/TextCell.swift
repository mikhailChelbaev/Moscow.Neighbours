//
//  TextCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

class TextCell: CellView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.tintColor = UIColor.projectRed
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.backgroundColor = .clear
        return textView
    }()
    
    var labelConstraints: AnchoredConstraints?
    
    override func configureView() {
        backgroundColor = .background
        
        addSubview(textView)
        labelConstraints = textView.pinToSuperviewEdges(.all, insets: .init(top: 12, left: 16, bottom: 12, right: 16))
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
        if let font = font {
            textView.font = font
        }
        textView.textColor = textColor
        textView.textContainer.maximumNumberOfLines = numberOfLines
        labelConstraints?.updateInsets(insets)
        
        if let attributedText = attributedText {
            textView.text = nil
            textView.attributedText = attributedText
        } else {
            textView.setAttributedText(text, kern: kern, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple)
        }
        
        self.backgroundColor = backgroundColor
    }
    
}
