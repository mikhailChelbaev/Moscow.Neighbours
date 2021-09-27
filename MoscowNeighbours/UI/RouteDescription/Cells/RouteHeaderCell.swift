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
    
    let startRouteButton: Button = {
        let button = Button()
        button.roundedCornders = true
        button.titleLabel?.font = .mainFont(ofSize: 17, weight: .bold)
        button.setTitle("Начать маршрут", for: .normal)
        return button
    }()
    
    override func commonInit() {
        super.commonInit()
        
        titleLabel.numberOfLines = 2
        
        addSubview(startRouteButton)
        startRouteButton.stickToSuperviewEdges([.left, .bottom], insets: .init(top: 0, left: 20, bottom: 20, right: 0))
        startRouteButton.height(42)
        
        addSubview(titleLabel)
        titleLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        titleLabel.bottom(15, to: startRouteButton)
        
        addSubview(durationInfo)
        durationInfo.bottom(10, to: titleLabel)
        durationInfo.leading(20)
    }
    
    func update(with route: Route, beginRouteAction: Action?) {
        imageView.image = UIImage(data: route.image)
        titleLabel.text = route.name
        distanceInfo.update(text: "200 m", image: sfSymbol("location.fill", tintColor: .white))
        durationInfo.update(text: "\(route.distance) • \(route.duration)", image: nil)
        startRouteButton.action = { _ in
            beginRouteAction?()
        }
    }
    
}
