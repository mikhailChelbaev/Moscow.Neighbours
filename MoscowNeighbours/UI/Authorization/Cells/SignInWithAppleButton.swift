//
//  SignInWithAppleButton.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 30.12.2021.
//

import UIKit
import AuthenticationServices

final class SignInWithAppleButton: CellView {
    
    enum Layout {
        static let buttonHeight: CGFloat = 42
    }
    
    let button: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default,
                                                  authorizationButtonStyle: .white)
        button.cornerRadius = Layout.buttonHeight / 2
        return button
    }()
    
    override func setUpView() {
        addSubview(button)
        button.stickToSuperviewEdges(.all,
                                     insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        button.height(Layout.buttonHeight)
    }
    
}
