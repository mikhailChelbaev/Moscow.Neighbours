//
//  AccountConfirmationNotificationCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import UIKit

final class AccountConfirmationNotificationCell: CellView {
    
    enum Layout {
        static var containerCornerRadius: CGFloat = 18
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .reversedBackground
        view.layer.cornerRadius = Layout.containerCornerRadius
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.text = "menu.account_confirmation_title".localized
        label.textColor = .reversedLabel
        label.numberOfLines = 0
        return label
    }()
    
    let button: Button = {
        let button = Button()
        button.roundedCorners = true
        button.setTitle("menu.account_confirmation_button".localized, for: .normal)
        return button
    }()
    
    var buttonAction: Action?
    
    override func configureView() {
        addSubview(containerView)
        containerView.pinToSuperviewEdges(.all,
                                            insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        containerView.addSubview(title)
        title.pinToSuperviewEdges([.left, .right, .top],
                                    insets: .init(top: 30, left: 20, bottom: 0, right: 20))
        
        containerView.addSubview(button)
        button.top(13, to: title)
        button.pinToSuperviewEdges([.left, .right, .bottom],
                                     insets: .init(top: 0, left: 20, bottom: 30, right: 20))
        button.height(42)
        
        button.action = { [weak self] in
            self?.buttonAction?()
        }
    }
    
}
