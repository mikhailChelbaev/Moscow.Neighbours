//
//  UIView+Shadow.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.08.2021.
//

import UIKit

extension UIView {
    
    func addShadow(
        color: UIColor = .shadow,
        radius: CGFloat = 10,
        opacity: Float = 1,
        offset: CGSize = .init(width: 0, height: 4)
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
    
    func updateShadowPath() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
}
