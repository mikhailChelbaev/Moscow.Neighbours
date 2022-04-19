//
//  PersonCell+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 19.04.2022.
//

import MoscowNeighbours

extension PersonCell {
    var personNameText: String? {
        return personNameLabel.text
    }
    
    var addressText: String? {
        return addressLabel.text
    }
    
    var houseTitleText: String? {
        return houseTitleLabel.text
    }
}
