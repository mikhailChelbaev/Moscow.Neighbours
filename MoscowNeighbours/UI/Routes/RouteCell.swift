//
//  RouteCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

final class RouteCell: CellView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mainFont(ofSize: 26, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mainFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let heroesNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let routeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    override func commonInit() {
        addSubview(headerLabel)
        headerLabel.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        addSubview(descriptionLabel)
        descriptionLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        descriptionLabel.top(12, to: headerLabel)
        
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
    
    func update(with route: Route) {
        headerLabel.text = route.name
        descriptionLabel.text = route.description
        heroesNumberLabel.text = "\(route.persons.count) героев"
        routeInfoLabel.text = "\(route.distance) • \(route.duration)"
        backgroundColor = route.color
    }
    
}
