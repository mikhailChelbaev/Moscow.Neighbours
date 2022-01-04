//
//  UserAccountPreviewCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.01.2022.
//

import UIKit
import ImageView

final class UserAccountPreviewCell: CellView {
    
    let imageView: ImageView = {
        let iv = ImageView()
        iv.placeholder = .symbol(name: "person.crop.circle",
                                 tintColor: .reversedBackground)
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func configureView() {
        addSubview(imageView)
        imageView.pinToSuperviewEdges([.left, .top, .bottom], constant: 20)
        imageView.exactSize(60)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        
        addSubview(stack)
        stack.trailing(20)
        stack.leading(15, to: imageView)
        stack.centerVertically(to: imageView)
    }
    
}
