//
//  PersonHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

// TODO: - add image placeholder
final class PersonHeaderCell: EntityHeaderCell {
    
    override func commonInit() {
        super.commonInit()
         
        addSubview(titleLabel)
        titleLabel.stickToSuperviewEdges([.left, .bottom, .right], insets: .init(top: 0, left: 20, bottom: 30, right: 20))
    }
    
    func update(name: String, image: UIImage) {
        titleLabel.text = name
        imageView.image = image
    }
    
}
