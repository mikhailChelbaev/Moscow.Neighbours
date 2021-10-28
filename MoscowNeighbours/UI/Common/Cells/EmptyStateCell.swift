//
//  EmptyStateCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 28.10.2021.
//

import UIKit

struct EmptyStateDataProvider {
    var title: String
    var subtitle: String?
    var buttonTitle: String?
    var buttonAction: Action?
}

struct DefaultEmptyStateProviders {
    
    static func mainError(action: Action?) -> EmptyStateDataProvider {
        EmptyStateDataProvider(title: "Не удалось загрузить страницу, попробуйте еще раз", subtitle: nil, buttonTitle: "Перезагрузить", buttonAction: action)
    }
    
}

final class EmptyStateCell: CellView {
    
    var dataProvider: EmptyStateDataProvider? {
        didSet {
            update()
        }
    }
    
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
    
    private var button: Button = .init()
    
    override func commonInit() {
        
    }
    
    
    private func update() {
        guard let data = dataProvider else { return }
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        
    }
}

