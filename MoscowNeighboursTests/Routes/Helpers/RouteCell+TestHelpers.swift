//
//  RouteCell+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import UIKit
@testable import MoscowNeighbours

extension RouteCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var buttonText: String? {
        return buyButton.titleLabel?.text
    }
}
