//
//  AchievementCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit
import ImageView

final class AchievementCell: CellView {
    
    let imageView: ImageView = {
        let iv = ImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let loader: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .medium
        return ai
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override func configureView() {
        let cellWidth = UIScreen.main.bounds.width / 3
        
        addSubview(imageView)
        imageView.pinToSuperviewEdges([.left, .top, .right], constant: 15)
        imageView.height(cellWidth - 30)
        
        imageView.addSubview(loader)
        loader.placeInCenter()
        
        addSubview(titleLabel)
        titleLabel.top(7, to: imageView)
        titleLabel.pinToSuperviewEdges([.left, .right], constant: 5)
        
        addSubview(dateLabel)
        dateLabel.top(4, to: titleLabel)
        dateLabel.pinToSuperviewEdges([.left, .right], constant: 5)
    }
    
}


