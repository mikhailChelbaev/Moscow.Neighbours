//
//  EndRouteButtonView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit
import UltraDrawerView

final class EndRouteButtonView: CellView {
    
    enum Settigns {
        static let buttonHeight: CGFloat = 38
        static let borderInsers: CGFloat = 10
        static var totalHeight = buttonHeight + 2 * borderInsers
        static let endRouteButtonText: String = "Завершить маршрут"
    }

    let endRouteButton: Button = {
        let button = Button()
        button.setTitle(Settigns.endRouteButtonText, for: .normal)
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
        button.layer.cornerRadius = Settigns.buttonHeight / 2
        button.backgroundColor = .background
        button.isHidden = true
        return button
    }()
    
    private var state: DrawerView.State = .top
    
    private var endRouteWidthAnimationConstraint: NSLayoutConstraint?
    
    override func commonInit() {
        addSubview(endRouteButton)
        endRouteButton.stickToSuperviewEdges([.top, .bottom], insets: .init(top: Settigns.borderInsers, left: 0, bottom: Settigns.borderInsers, right: 0))
        endRouteButton.centerHorizontally()
        endRouteButton.height(Settigns.buttonHeight)
        endRouteWidthAnimationConstraint = endRouteButton.width(Settigns.buttonHeight)
        endRouteWidthAnimationConstraint?.isActive = false
        
        addSubview(openDrawerButton)
        openDrawerButton.stickToSuperviewEdges([.top, .bottom], insets: .init(top: Settigns.borderInsers, left: 0, bottom: Settigns.borderInsers, right: 0))
        openDrawerButton.centerHorizontally()
        openDrawerButton.exactSize(.init(width: Settigns.buttonHeight , height: Settigns.buttonHeight ))
        sendSubviewToBack(openDrawerButton)
        
        
//        addSubview(openDrawerButton)
//        openDrawerButton.trailing(20)
//        openDrawerButton.centerVertically(to: endRouteButton)
//        openDrawerButton.exactSize(.init(width: Layout.buttonHeight , height: Layout.buttonHeight ))
    }
    
    func update(endRouteAction: Button.Action?, opendDrawerButtonAction: Button.Action?) {
        endRouteButton.action = endRouteAction
        openDrawerButton.action = opendDrawerButtonAction
    }
    
//    func updateOpenDrawerButtonState(isHidden: Bool) {
//        UIView.transition(with: openDrawerButton, duration: 0.3, options: .transitionCrossDissolve) {
//            self.openDrawerButton.isHidden = isHidden
//        }
//    }
    
    func changeViewState(_ newState: DrawerView.State) {
        guard state != newState else { return }

        if newState == .bottom {
            UIView.animate(withDuration: 0.2) {
                self.endRouteWidthAnimationConstraint?.isActive = true
                self.endRouteButton.setTitle("", for: .normal)
                self.layoutIfNeeded()
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.endRouteButton.isHidden = true
                    self.openDrawerButton.isHidden = false
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.endRouteButton.isHidden = false
                self.endRouteWidthAnimationConstraint?.isActive = false
                self.endRouteButton.setTitle(Settigns.endRouteButtonText, for: .normal)
                self.layoutIfNeeded()
            } completion: { _ in
                self.openDrawerButton.isHidden = true
            }
        }
        
        state = newState
    }
    
}

