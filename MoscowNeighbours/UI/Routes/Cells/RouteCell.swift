//
//  RouteCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class RouteCell: CellView {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mainFont(ofSize: 26, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mainFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let heroesNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let routeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.addShadow()
        return view
    }()
    
    override func commonInit() {
        clipsToBounds = false
        
        containerView.addSubview(headerLabel)
        headerLabel.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        descriptionLabel.top(12, to: headerLabel)
        
        containerView.addSubview(routeInfoLabel)
        routeInfoLabel.top(12, to: descriptionLabel)
        routeInfoLabel.trailing(16)
        routeInfoLabel.bottom(16)
        
        containerView.addSubview(heroesNumberLabel)
        heroesNumberLabel.top(12, to: descriptionLabel)
        heroesNumberLabel.leading(16)
        heroesNumberLabel.trailing(8, to: routeInfoLabel)
        heroesNumberLabel.bottom(16)
        
        addSubview(containerView)
        containerView.stickToSuperviewEdges(.all, insets: .init(top: 6, left: 16, bottom: 6, right: 16))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.updateShadowPath()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        containerView.layer.shadowColor = UIColor.shadow.cgColor
    }
    
    func update(with route: Route) {
        headerLabel.text = route.name
        descriptionLabel.text = route.description
        heroesNumberLabel.text = "\(route.personsInfo.count) героев"
        routeInfoLabel.text = "\(route.distance) • \(route.duration)"
        containerView.backgroundColor = route.color
    }
    
}
