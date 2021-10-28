//
//  RouteHeaderView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

final class HeaderView: CellView {
    
    enum Settings {
        static var buttonSide: CGFloat = 28
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .mainFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeController), for: .touchUpInside)
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    private var buttonCloseAction: Action?
    
    override func commonInit() {
        backgroundColor = .background
        
        addSubview(closeButton)
        closeButton.height(Settings.buttonSide)
        buttonWidthConstraint = closeButton.width(Settings.buttonSide)
        closeButton.trailing(16)
        closeButton.centerVertically()
        
        addSubview(label)
        label.centerVertically()
        label.leading(16)
        label.trailing(16, to: closeButton)
        
        addSubview(separator)
        separator.stickToSuperviewEdges([.left, .right, .bottom])
        separator.height(0.5)
    }
    
    func update(text: String, showSeparator: Bool = true, buttonCloseAction: Action? = nil) {
        label.text = text
        separator.isHidden = !showSeparator
        if buttonCloseAction != nil {
            self.buttonCloseAction = buttonCloseAction
            buttonWidthConstraint?.constant = Settings.buttonSide
            closeButton.isHidden = false
        } else {
            buttonWidthConstraint?.constant = 0
            closeButton.isHidden = true
        }
    }
    
    @objc private func closeController() {
        buttonCloseAction?()
    }
    
}
