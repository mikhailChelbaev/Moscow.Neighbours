//
//  UIFont+CurrentFont.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

extension UIFont {
    
    static func mainFont(ofSize size: CGFloat, weight: Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "helveticaneuecyr-roman", size: size)!
        case .medium:
            return UIFont(name: "helveticaneuecyr-medium", size: size)!
        case .bold:
            return UIFont(name: "helveticaneuecyr-bold", size: size)!
        default:
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
}
