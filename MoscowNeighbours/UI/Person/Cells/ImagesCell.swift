//
//  ImagesCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.08.2021.
//

import UIKit

// NOTE: - depricated
final class ImagesCell: CellView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    override func commonInit() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.stickToSuperviewEdges(.all, insets: .init(top: 10, left: 16, bottom: 10, right: 16))
        imageView.height(160)
    }
    
    func update(image: UIImage?) {
        imageView.image = image
    }
    
}
