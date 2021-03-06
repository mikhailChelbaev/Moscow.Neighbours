//
//  RouteCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.09.2021.
//

import UIKit
import ImageView

final class RouteCell: CellView {
    
    let containerView: ImageView = {
        let iv = ImageView()
        iv.backgroundColor = .imageBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let gradientView: GradientView = {
        let view = GradientView()
        if let layer = view.layer as? CAGradientLayer {
            layer.colors = [
                UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
            ]
        }
        return view
    }()
    
    let buyButton: Button = {
        let button = Button()
        button.roundedCorners = true
        button.contentEdgeInsets = .init(top: 8, left: 13, bottom: 8, right: 13)
        return button
    }()
    
    let infoView: InfoView = .init()
    
    override func configureView() {
        backgroundColor = .background
        clipsToBounds = false
        
        addSubview(containerView)
        containerView.pinToSuperviewEdges(.all, insets: .init(top: 5, left: 20, bottom: 5, right: 20))
        containerView.height(194)
        
        containerView.addSubview(gradientView)
        gradientView.pinToSuperviewEdges([.left, .bottom, .right])
        gradientView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
        
        containerView.addSubview(buyButton)
        buyButton.pinToSuperviewEdges([.left, .bottom], constant: 20)
        
        containerView.addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges([.left, .right], constant: 20)
        titleLabel.bottom(10, to: buyButton)
        
        containerView.addSubview(infoView)
        infoView.pinToSuperviewEdges([.left, .top], insets: .init(top: 20, left: 20, bottom: 0, right: 0))
    }
    
}
