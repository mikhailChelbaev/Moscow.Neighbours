//
//  LegacyRouteHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.09.2021.
//

import UIKit

final class LegacyRouteHeaderCell: EntityHeaderCell {
    
    let routeInfo: InfoView = .init()
    
    let button: Button = {
        let button = Button()
        button.roundedCorners = true
        button.titleLabel?.font = .mainFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    override func configureView() {
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
    
    func update(route: LegacyRouteViewModel?, buttonTapped: Action?) {
        guard let route = route else {
            return
        }
        
        imageView.loadImage(route.coverUrl)
        titleLabel.text = route.name
        routeInfo.update(text: route.routeInformation, image: nil)
        
        if route.purchaseStatus == .buy {
            button.setTitle(route.price, for: .normal)
            
        } else {
            button.setTitle("route_description.start_route".localized, for: .normal)
        }
        
        button.isEnabled = true
        button.action = buttonTapped
        
        buttonWidthConstraint?.isActive = false
    }
    
    func showButtonLoader() {
        button.isEnabled = false
        button.setTitle("", for: .normal)
        
        let width = button.frame.width
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        
        button.addSubview(activityIndicator)
        activityIndicator.placeInCenter()
        
        buttonWidthConstraint?.isActive = false
        buttonWidthConstraint = button.width(width)
        buttonWidthConstraint?.isActive = true
    }
    
}
