//
//  RouteHeaderView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

final class RouteHeaderView: UIView {
    
    enum Settings {
        static var buttonSide: CGFloat = 28
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .mainFont(ofSize: 22, weight: .semibold)
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
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(text: String, buttonCloseAction: Action? = nil) {
        label.text = text
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
