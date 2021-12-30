//
//  AuthorizationTypeCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.12.2021.
//

import UIKit

final class AuthorizationTypeCell: CellView {
    
    typealias AuthorizationTypeCompletion = (AuthorizationType) -> Void
    
    enum ButtonStyle {
        case selected
        case deselected
    }
    
    lazy var signInButton: UIButton = createButton(title: "Вход")
    lazy var signUpButton: UIButton = createButton(title: "Регистрация")
    
    var authorizationTypeDidChange: AuthorizationTypeCompletion?
    
    override func setUpView() {
        let stack = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        stack.axis = .horizontal
        stack.spacing = 20
        
        addSubview(stack)
        stack.stickToSuperviewEdges([.top, .bottom],
                                    insets: .init(top: 10, left: 0, bottom: 30, right: 0))
        stack.centerHorizontally()
        
        setStyle(button: signInButton, style: .selected)
        setStyle(button: signUpButton, style: .deselected)
        
        signInButton.addTarget(self, action: #selector(onAuthorizationTypeButtonTap), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(onAuthorizationTypeButtonTap), for: .touchUpInside)
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .mainFont(ofSize: 24, weight: .bold)
        return button
    }
    
    private func setStyle(button: UIButton, style: ButtonStyle) {
        let color: UIColor = style == .selected ? .white : .secondaryLabel
        button.setTitleColor(color, for: .normal)
    }
    
    private func select(button: UIButton) {
        if button == signInButton {
            setStyle(button: signInButton, style: .selected)
            setStyle(button: signUpButton, style: .deselected)
        } else {
            setStyle(button: signUpButton, style: .selected)
            setStyle(button: signInButton, style: .deselected)
        }
    }
    
    @objc private func onAuthorizationTypeButtonTap(_ sender: UIButton) {
        if sender == signInButton {
            select(button: signInButton)
            authorizationTypeDidChange?(.signIn)
        } else {
            select(button: signUpButton)
            authorizationTypeDidChange?(.signUp)
        }
    }
    
}
