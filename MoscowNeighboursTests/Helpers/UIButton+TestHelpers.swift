//
//  UIButton+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import UIKit

extension UIButton {
    @objc func simulateTap() {
        sendActions(for: .touchUpInside)
    }
}
