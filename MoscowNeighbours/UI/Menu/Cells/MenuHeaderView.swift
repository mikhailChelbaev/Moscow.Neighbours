//
//  MenuHeaderView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

final class MenuHeaderView: CellView {
    
    enum Layout {
        static let buttonSide: CGFloat = 46
        static var pullViewBorderInsets: CGFloat = 8
        static var pullViewHeight: CGFloat = 4
        static var pullViewWidth: CGFloat = 34
        static var cornerRadius: CGFloat = 29
    }
    
    let handlerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayBackground
        button.setImage(#imageLiteral(resourceName: "backButton").withTintColor(.reversedBackground, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        return button
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.text = "menu.title".localized
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    var backButtonAction: Action?
    
    override func configureView() {
        addSubview(handlerView)
        handlerView.top(Layout.pullViewBorderInsets)
        handlerView.centerHorizontally()
        handlerView.exactSize(.init(width: Layout.pullViewWidth, height: Layout.pullViewHeight))
        
        addSubview(containerView)
        containerView.pinToSuperviewEdges([.left, .right, .bottom])
        containerView.top(Layout.pullViewBorderInsets, to: handlerView)
        
        containerView.addSubview(backButton)
        backButton.pinToSuperviewEdges([.left, .top, .bottom], insets: .init(top: 20, left: 20, bottom: 20, right: 0))
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
        
        containerView.addSubview(title)
        title.leading(15, to: backButton)
        title.centerVertically()
        
        containerView.addSubview(separator)
        separator.pinToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        separator.height(0.5)
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.updateShadowPath()
    }
    
    @objc private func handleBackButton() {
        backButtonAction?()
    }
    
}
