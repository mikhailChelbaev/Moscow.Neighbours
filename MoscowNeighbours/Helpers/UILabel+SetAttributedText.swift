//
//  UILabel+SetAttributedText.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.09.2021.
//

import UIKit

extension UILabel {
    
    func setAttributedText(
        _ text: String?,
        kern: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil
    ) {
        var attributes: [NSAttributedString.Key : Any] = [
            .font: font ?? .mainFont(ofSize: 17, weight: .regular),
            .foregroundColor: textColor ?? .label,
            
        ]
        
        if let kern = kern {
            attributes[.kern] = kern
        }
        
        let style: NSMutableParagraphStyle = .init()
        style.alignment = textAlignment
        if let lineSpacing = lineSpacing {
            style.lineSpacing = lineSpacing
        }
        if let lineHeightMultiple = lineHeightMultiple {
            style.lineHeightMultiple = lineHeightMultiple
        }
        attributes[.paragraphStyle] = style
        
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
}
