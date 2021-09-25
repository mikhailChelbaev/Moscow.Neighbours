//
//  AlertCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

final class AlertCell: CellView {
    
    enum Image: String {
        case exclamationMark = "exclamationmark.circle"
        case checkmark = "checkmark.circle"
        
        var value: UIImage? {
            sfSymbol(rawValue, tintColor: .inversedBackground)
        }
    }
    
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
        iv.clipsToBounds = true
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
        imageView.exactSize(.init(width: 20, height: 20))
        
        container.addSubview(label)
        label.stickToSuperviewEdges([.top, .right], insets: .init(top: 20, left: 0, bottom: 0, right: 20))
        label.leading(9, to: imageView)
        label.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -20).isActive = true
    }
    
    func update(
        text: String,
        image: Image = .exclamationMark,
        containerInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    ) {
        label.text = text
        imageView.image = image.value
        containerConstraints?.updateInsets(containerInsets)
    }
    
}
