//
//  MenuItemCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

final class MenuItemCell: CellView {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func configureView() {
        addSubview(title)
        title.pinToSuperviewEdges([.top, .left, .right],
                                    insets: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        addSubview(subtitle)
        subtitle.top(7, to: title)
        subtitle.pinToSuperviewEdges([.bottom, .left, .right],
                                       insets: .init(top: 0, left: 20, bottom: 20, right: 20))
    }
    
}
