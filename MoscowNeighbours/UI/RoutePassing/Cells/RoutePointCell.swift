//
//  RoutePointCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class RoutePointCell: CellView {
    
    enum State {
        case onTheSpot
        case going
    }
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    let alertView: AlertCell = .init()
    
    let button: Button = {
        let button = Button()
        button.titleLabel?.font = .mainFont(ofSize: 18, weight: .bold)
        button.setTitle("Познакомиться с соседом", for: .normal)
        button.roundedCornders = true
        return button
    }()
    
    override func commonInit() {
        addSubview(placeNameLabel)
        placeNameLabel.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        addSubview(addressLabel)
        addressLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        addressLabel.top(4, to: placeNameLabel)
        
        addSubview(alertView)
        alertView.stickToSuperviewEdges([.left, .right])
//        alertView.topAnchor.constraint(greaterThanOrEqualTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        let constraint = alertView.top(10, to: addressLabel)
        constraint.priority = .defaultLow
        
        addSubview(button)
        button.stickToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 20, bottom: 20, right: 20))
        button.height(42)
        button.top(10, to: alertView)
        
    }
    
    func update(
        personInfo: PersonInfo,
        state: State,
        action: Button.Action?
    ) {
        placeNameLabel.text = personInfo.place.name
        addressLabel.text = personInfo.place.address
        
        if state == .onTheSpot {
            button.style = .filled
            alertView.update(text: "Вы можете начать свое знакомство с героем", image: .checkmark)
            button.isEnabled = true
            button.action = action
        } else {
            button.style = .custom(title: .label.withAlphaComponent(0.5), background: .grayBackground)
            alertView.update(text: "Чтобы начать знакомство, подойдите ближе к локации", image: .exclamationMark)
            button.isEnabled = false
            button.action = nil
        }
    }
    
}
