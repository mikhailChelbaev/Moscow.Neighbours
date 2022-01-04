//
//  SignInWithAppleButtonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.12.2021.
//

import UIKit
import AuthenticationServices

final class SignInWithAppleButtonCell: CellView {
    
    enum Layout {
        static let buttonHeight: CGFloat = 42
    }
    
    let button: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default,
                                                  authorizationButtonStyle: .white)
        button.cornerRadius = Layout.buttonHeight / 2
        return button
    }()
    
    var onSignInWithAppleButtonTap: Action?
    
    override func configureView() {
        addSubview(button)
        button.pinToSuperviewEdges(.all,
                                     insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        button.height(Layout.buttonHeight)
        
        button.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    
    @objc private func handleAppleIdRequest() {
        onSignInWithAppleButtonTap?()
    }
    
}
