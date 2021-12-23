//
//  EmptyStateCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 28.10.2021.
//

import UIKit

struct EmptyStateDataProvider {
    var image: UIImage?
    var title: String
    var subtitle: String?
    var buttonTitle: String?
    var buttonAction: Action?
}

struct DefaultEmptyStateProviders {
    
    static func mainError(action: Action?) -> EmptyStateDataProvider {
        EmptyStateDataProvider(image: #imageLiteral(resourceName: "error_placeholder"), title: "Не удалось загрузить страницу, попробуйте еще раз", subtitle: nil, buttonTitle: "Перезагрузить", buttonAction: action)
    }
    
}

final class EmptyStateCell: CellView {
    
    var dataProvider: EmptyStateDataProvider? {
        didSet {
            update()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var button: Button = {
        let button = Button()
        button.roundedCorners = true
        return button
    }()
    
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    override func commonInit() {
        addSubview(imageView)
        imageView.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        imageView.height(150)
        
        addSubview(titleLabel)
        titleLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        titleLabel.top(20, to: imageView)
        
        addSubview(subtitleLabel)
        subtitleLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        subtitleLabel.top(20, to: titleLabel)
        
        addSubview(button)
        button.top(10, to: subtitleLabel)
        button.bottom(20)
        button.height(40)
        button.centerHorizontally()
    }
    
    
    private func update() {
        guard let data = dataProvider else { return }
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        imageView.image = data.image
        button.setTitle(data.buttonTitle, for: .normal)
        button.action = { _ in
            data.buttonAction?()
        }
    }
}

