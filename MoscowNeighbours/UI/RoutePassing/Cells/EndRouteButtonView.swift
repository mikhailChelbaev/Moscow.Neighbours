//
//  EndRouteButtonView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit
import UltraDrawerView

final class EndRouteButtonView: CellView {
    
    enum Settings {
        static let buttonHeight: CGFloat = 38
        static let borderInsets: CGFloat = 10
        static var totalHeight = buttonHeight + 2 * borderInsets
        static let endRouteButtonText: String = "Завершить маршрут"
    }

    let endRouteButton: Button = {
        let button = Button()
        button.setTitle(Settings.endRouteButtonText, for: .normal)
        button.titleLabel?.font = .mainFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .background
        button.setTitleColor(.label, for: .normal)
        button.roundedCorners = true
        return button
    }()
    
    let         arrowUpButton: Button = {
        let button = Button()
        button.setImage(sfSymbol("arrow.up", tintColor: .reversedBackground), for: .normal)
        button.contentEdgeInsets = .zero
        button.layer.cornerRadius = Settings.buttonHeight / 2
        button.backgroundColor = .background
        button.isHidden = true
        return button
    }()
    
    private var state: DrawerView.State = .top
    
    override func configureView() {
        addSubview(endRouteButton)
        endRouteButton.pinToSuperviewEdges([.top, .bottom], insets: .init(top: Settings.borderInsets, left: 0, bottom: Settings.borderInsets, right: 0))
        endRouteButton.centerHorizontally()
        endRouteButton.height(Settings.buttonHeight)
        
        addSubview(        arrowUpButton)
                arrowUpButton.pinToSuperviewEdges([.top, .bottom], insets: .init(top: Settings.borderInsets, left: 0, bottom: Settings.borderInsets, right: 0))
                arrowUpButton.centerHorizontally()
                arrowUpButton.exactSize(.init(width: Settings.buttonHeight , height: Settings.buttonHeight ))
        sendSubviewToBack(        arrowUpButton)
    }
    
    func update(endRouteAction: Action?,
                arrowUpButtonAction: Action?) {
        endRouteButton.action = endRouteAction
        arrowUpButton.action = arrowUpButtonAction
    }
    
    func changeViewState(_ newState: DrawerView.State) {
        guard state != newState else { return }

        if newState == .bottom {
            UIView.animate(withDuration: 0.2) {
                self.endRouteButton.transform = .init(translationX: 0.4, y: 1)
                self.endRouteButton.setTitle("", for: .normal)
                self.layoutIfNeeded()
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.endRouteButton.isHidden = true
                    self.arrowUpButton.isHidden = false
                }
            }
        } else {
            endRouteButton.isHidden = false
            endRouteButton.setTitle(Settings.endRouteButtonText, for: .normal)
            endRouteButton.setTitleColor(.clear, for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.endRouteButton.transform = .identity
                self.layoutIfNeeded()
            } completion: { _ in
                self.endRouteButton.setTitleColor(.label, for: .normal)
                self.arrowUpButton.isHidden = true
            }
        }
        
        state = newState
    }
    
}

