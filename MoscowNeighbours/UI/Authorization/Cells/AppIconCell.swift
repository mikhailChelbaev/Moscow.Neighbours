//
//  AppIconCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

final class AppIconCell: CellView {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo_icon_red")?.withTintColor(.projectRed, renderingMode: .alwaysOriginal)
        return iv
    }()
    
    override func setUpView() {
        addSubview(imageView)
        imageView.centerHorizontally()
        imageView.stickToSuperviewEdges([.top, .bottom], insets: .init(top: 50, left: 0, bottom: 50, right: 0))
        imageView.exactSize(.init(width: 72, height: 96))
    }
    
}
