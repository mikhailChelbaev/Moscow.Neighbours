//
//  Button+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 10.04.2022.
//

import MoscowNeighbours

extension Button {
    override func simulateTap() {
        action?()
    }
}
