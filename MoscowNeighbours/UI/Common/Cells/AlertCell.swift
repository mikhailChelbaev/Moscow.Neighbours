//
//  AlertCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

final class AlertCell: CellView {
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .grayBackground
        view.layer.cornerRadius = 18
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = sfSymbol("exclamationmark.circle", tintColor: .inversedBackground)
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    var containerConstraints: AnchoredConstraints?
    
    override func commonInit() {
        addSubview(container)
        containerConstraints = container.stickToSuperviewEdges([.left, .right, .top, .bottom], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        container.addSubview(imageView)
        imageView.stickToSuperviewEdges([.left, .top], insets: .init(top: 20, left: 20, bottom: 0, right: 0))
        imageView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -20).isActive = true
        
        container.addSubview(label)
        label.stickToSuperviewEdges([.top, .right], insets: .init(top: 20, left: 0, bottom: 0, right: 20))
        label.leading(9, to: imageView)
        label.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -20).isActive = true
    }
    
    func update(text: String, containerInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)) {
        label.text = text
        containerConstraints?.updateInsets(containerInsets)
    }
    
}
