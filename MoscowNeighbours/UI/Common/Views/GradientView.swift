//
//  GradientView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.09.2021.
//

import UIKit

final class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }

    private func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        guard let gradientLayer = self.layer as? CAGradientLayer else { return }

        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        ]
    }
}
