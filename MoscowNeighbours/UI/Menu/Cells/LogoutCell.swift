//
//  LogoutCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import UIKit

final class LogoutCell: CellView {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.text = "menu.logout".localized
        label.textColor = .projectRed
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "log-out")?.withTintColor(.projectRed)
        return iv
    }()
    
    override func configureView() {
        addSubview(title)
        title.pinToSuperviewEdges([.left, .top, .bottom], constant: 20)
        
        addSubview(imageView)
        imageView.centerVertically(to: title)
        imageView.exactSize(24)
        imageView.trailing(20)
        
        title.trailing(12, to: imageView)
    }
    
}
