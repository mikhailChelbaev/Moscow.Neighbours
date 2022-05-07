//
//  UIFont+MainFont.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.05.2022.
//

import UIKit
import AppConfiguration

extension UIFont {
    static func mainFont(ofSize size: CGFloat, weight: Font.Weight) -> UIFont {
        return Font.main(ofSize: size, weight: weight)
    }
}
