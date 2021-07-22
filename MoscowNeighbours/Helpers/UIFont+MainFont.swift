//
//  UIFont+CurrentFont.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

extension UIFont {
    
    static func mainFont(ofSize size: CGFloat, weight: Weight) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
    
}
