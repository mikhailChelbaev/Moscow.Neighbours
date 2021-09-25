//
//  EndRouteButtonView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class EndRouteButtonView: CellView {
    
    enum Layout {
        static let buttonHeight: CGFloat = 38
        static let borderInsers: CGFloat = 10
        static var totalHeight = buttonHeight + 2 * borderInsers
    }

    let endRouteButton: Button = {
        let button = Button()
        button.setTitle("Завершить маршрут", for: .normal)
        button.titleLabel?.font = .mainFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .background
        button.setTitleColor(.label, for: .normal)
        button.roundedCornders = true
        return button
    }()
    
    let openDrawerButton: Button = {
        let button = Button()
        button.setImage(sfSymbol("arrow.up", tintColor: .inversedBackground), for: .normal)
        button.contentEdgeInsets = .zero
        button.layer.cornerRadius = Layout.buttonHeight / 2
        button.backgroundColor = .background
        button.isHidden = true
        return button
    }()
    
    override func commonInit() {
        addSubview(endRouteButton)
        endRouteButton.stickToSuperviewEdges([.top, .bottom], insets: .init(top: Layout.borderInsers, left: 0, bottom: Layout.borderInsers, right: 0))
        endRouteButton.centerHorizontally()
        endRouteButton.height(Layout.buttonHeight)
        
        addSubview(openDrawerButton)
        openDrawerButton.trailing(20)
        openDrawerButton.centerVertically(to: endRouteButton)
        openDrawerButton.exactSize(.init(width: Layout.buttonHeight , height: Layout.buttonHeight ))
    }
    
    func update(endRouteAction: Button.Action?, opendDrawerButtonAction: Button.Action?) {
        endRouteButton.action = endRouteAction
        openDrawerButton.action = opendDrawerButtonAction
    }
    
    func updateOpenDrawerButtonState(isHidden: Bool) {
        UIView.transition(with: openDrawerButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.openDrawerButton.isHidden = isHidden
        }
    }
    
}

