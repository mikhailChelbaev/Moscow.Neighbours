//
//  RouteHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

public final class RouteHeaderCell: EntityHeaderCell {
    public let routeInfo = InfoView()
    
    public let button: Button = {
        let button = Button()
        button.roundedCorners = true
        button.titleLabel?.font = .mainFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    public override func configureView() {
        super.configureView()
        
        titleLabel.numberOfLines = 2
        
        addSubview(button)
        button.pinToSuperviewEdges([.left, .bottom], insets: .init(top: 0, left: 20, bottom: 20, right: 0))
        button.height(42)
        
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        titleLabel.bottom(15, to: button)
        
        addSubview(routeInfo)
        routeInfo.bottom(10, to: titleLabel)
        routeInfo.leading(20)
    }
}
