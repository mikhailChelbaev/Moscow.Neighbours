//
//  RoutePointCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class RoutePointCell: CellView {
    
    enum State {
        case firstTime
        case review
        case notVisited
    }
    
    let personNameLabel: UILabel = {
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
        button.roundedCorners = true
        return button
    }()
    
    override func setUpView() {
        addSubview(personNameLabel)
        personNameLabel.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        addSubview(addressLabel)
        addressLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        addressLabel.top(4, to: personNameLabel)
        
        addSubview(alertView)
        alertView.stickToSuperviewEdges([.left, .right])
        alertView.topAnchor.constraint(greaterThanOrEqualTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        
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
        personNameLabel.text = personInfo.person.name
        addressLabel.text = personInfo.place.address
        
        switch state {
        case .firstTime:
            button.style = .filled
            alertView.update(text: "Вы можете начать свое знакомство с героем", image: .checkmark)
            button.isEnabled = true
            button.action = action
            button.setTitle("Познакомиться с соседом", for: .normal)
        case .review:
            button.style = .filled
            alertView.update(text: "Вы можете прочитать про этого героя в любой момент", image: .checkmark)
            button.isEnabled = true
            button.action = action
            button.setTitle("Посмотреть еще раз", for: .normal)
        case .notVisited:
            button.style = .custom(title: .label.withAlphaComponent(0.5), background: .grayBackground)
            alertView.update(text: "Чтобы начать знакомство, подойдите ближе к локации", image: .exclamationMark)
            button.isEnabled = false
            button.action = nil
            button.setTitle("Познакомиться с соседом", for: .normal)
        }
    }
    
}
