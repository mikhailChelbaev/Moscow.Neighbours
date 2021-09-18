//
//  RouteHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.09.2021.
//

import UIKit

final class RouteHeaderCell: EntityHeaderCell {
    
    let distanceInfo: InfoView = .init()
    
    let durationInfo: InfoView = .init()
    
    override func commonInit() {
        super.commonInit()
        
        titleLabel.numberOfLines = 2
        
        addSubview(titleLabel)
        titleLabel.stickToSuperviewEdges([.left, .bottom, .right], insets: .init(top: 0, left: 20, bottom: 30, right: 20))
        
        addSubview(durationInfo)
        durationInfo.bottom(10, to: titleLabel)
        durationInfo.leading(20)
    }
    
    func update(with route: Route) {
        titleLabel.text = route.name
        distanceInfo.update(text: "200 m", image: sfSymbol("location.fill", tintColor: .white))
        durationInfo.update(text: "\(route.distance) • \(route.duration)", image: nil)
    }
    
}
