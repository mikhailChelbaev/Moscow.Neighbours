//
//  BackButtonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.04.2022.
//

import UIKit

final class BackButtonViewController {
    private let buttonAction: Action?
    
    init(onBackButtonTap: Action?) {
        self.buttonAction = onBackButtonTap
    }
    
    private static var image: UIImage? {
        return UIImage(named: "backButton")
    }
    
    enum Layout {
        static let buttonSide: CGFloat = 46
    }
    
    func view() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(BackButtonViewController.image, for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        button.makeShadow()
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }
    
    @objc private func handleButtonTap() {
        buttonAction?()
    }
}
