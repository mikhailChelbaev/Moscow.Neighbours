//
//  UIFont+CurrentFont.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

extension UIFont {

    enum FontWeight {
        case regular
        case medium
        case bold
        case italic
        case boldItalic
    }
    
    static func mainFont(ofSize size: CGFloat, weight: FontWeight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "helveticaneuecyr-roman", size: size)!
        case .medium:
            return UIFont(name: "helveticaneuecyr-medium", size: size)!
        case .bold:
            return UIFont(name: "helveticaneuecyr-bold", size: size)!
        case .italic:
            return UIFont(name: "helveticaneuecyr-italic", size: size)!
        case .boldItalic:
            return UIFont(name: "helveticaneuecyr-bolditalic", size: size)!
        }
    }
    
}
