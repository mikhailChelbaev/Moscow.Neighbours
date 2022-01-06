//
//  ToggleSettingsCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import UIKit

final class ToggleSettingsCell: CellView {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .projectRed
        return toggle
    }()
    
    var valueChanged: ((Bool) -> Void)?
    
    override func configureView() {
        addSubview(toggle)
        toggle.trailing(20)
        toggle.centerVertically()
        
        addSubview(title)
        title.pinToSuperviewEdges([.top, .left], constant: 20)
        title.trailing(10, to: toggle)
        
        addSubview(subtitle)
        subtitle.top(7, to: title)
        subtitle.pinToSuperviewEdges([.bottom, .left], constant: 20)
        subtitle.trailing(10, to: toggle)
        
        toggle.addTarget(self, action: #selector(handleToggleValueChange), for: .valueChanged)
    }
    
    @objc private func handleToggleValueChange() {
        valueChanged?(toggle.isOn)
    }
    
}
