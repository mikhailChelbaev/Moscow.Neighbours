//
//  RouteDescriptionCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.07.2021.
//

import UIKit

final class RouteDescriptionCell: RouteCell {
    
    override func commonInit() {
        addSubview(descriptionLabel)
        descriptionLabel.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        addSubview(routeInfoLabel)
        routeInfoLabel.top(12, to: descriptionLabel)
        routeInfoLabel.trailing(16)
        routeInfoLabel.bottom(16)
        
        addSubview(heroesNumberLabel)
        heroesNumberLabel.top(12, to: descriptionLabel)
        heroesNumberLabel.leading(16)
        heroesNumberLabel.trailing(8, to: routeInfoLabel)
        heroesNumberLabel.bottom(16)
    }
    
}
