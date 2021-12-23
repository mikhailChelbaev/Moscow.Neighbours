//
//  ButtonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.08.2021.
//

import UIKit

final class ButtonCell: CellView {
    
    let button: Button = .init()
    
    private var buttonConstraints: AnchoredConstraints?
    
    override func commonInit() {
        addSubview(button)
        buttonConstraints = button.stickToSuperviewEdges(.all, insets: .init(top: 10, left: 16, bottom: 10, right: 16))
        buttonConstraints?.height = button.height(48)
    }
    
    func update(
        title: String,
        insets: UIEdgeInsets = .init(top: 10, left: 16, bottom: 10, right: 16),
        color: UIColor = .projectRed,
        roundedCorners: Bool = true,
        height: CGFloat = 48,
        action: Button.Action?
    ) {
        button.setTitle(title, for: .normal)
        buttonConstraints?.updateInsets(insets)
        button.backgroundColor = color
        button.action = action
        button.roundedCorners = roundedCorners
        buttonConstraints?.height?.constant = height
    }
    
}
