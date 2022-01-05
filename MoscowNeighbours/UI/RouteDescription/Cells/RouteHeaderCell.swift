//
//  RouteHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.09.2021.
//

import UIKit

final class RouteHeaderCell: EntityHeaderCell {
    
    var route: RouteViewModel? {
        didSet { update() }
    }
    
    var beginRouteAction: Action?
    
    let routeInfo: InfoView = .init()
    
    let startRouteButton: Button = {
        let button = Button()
        button.roundedCorners = true
        button.titleLabel?.font = .mainFont(ofSize: 17, weight: .bold)
        button.setTitle("route_description.start_route".localized, for: .normal)
        return button
    }()
    
    override func configureView() {
        super.configureView()
        
        titleLabel.numberOfLines = 2
        
        addSubview(startRouteButton)
        startRouteButton.pinToSuperviewEdges([.left, .bottom], insets: .init(top: 0, left: 20, bottom: 20, right: 0))
        startRouteButton.height(42)
        
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        titleLabel.bottom(15, to: startRouteButton)
        
        addSubview(routeInfo)
        routeInfo.bottom(10, to: titleLabel)
        routeInfo.leading(20)
    }
    
    func update() {
        guard let route = route else {
            return
        }
        
        imageView.loadImage(route.coverUrl)
        titleLabel.text = route.name
        routeInfo.update(text: route.routeInformation, image: nil)
        startRouteButton.action = { [weak self] in
            self?.beginRouteAction?()
        }
    }
    
}
