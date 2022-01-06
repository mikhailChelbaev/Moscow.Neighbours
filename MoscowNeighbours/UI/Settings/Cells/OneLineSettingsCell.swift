//
//  OneLineSettingsCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import UIKit

final class OneLineSettingsCell: CellView {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    override func configureView() {
        addSubview(title)
        title.pinToSuperviewEdges(.all, constant: 20)
    }
    
}
