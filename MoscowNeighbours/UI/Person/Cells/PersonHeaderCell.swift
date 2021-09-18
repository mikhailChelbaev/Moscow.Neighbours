//
//  PersonHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

// TODO: - add image placeholder
final class PersonHeaderCell: EntityHeaderCell {
    
    func update(name: String, image: UIImage) {
        titleLabel.text = name
        imageView.image = image
    }
    
}
