//
//  PersonHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

// TODO: - add image placeholder
final class PersonHeaderCell: EntityHeaderCell {    
    override func configureView() {
        super.configureView()
         
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges([.left, .bottom, .right], insets: .init(top: 0, left: 20, bottom: 30, right: 20))
    }
}
