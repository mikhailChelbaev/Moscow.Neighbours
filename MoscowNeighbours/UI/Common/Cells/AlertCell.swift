//
//  AlertCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

enum AlertImage: String {
    case exclamationMark = "exclamationmark.circle"
    case checkmark = "checkmark.circle"
}

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
    
    override func configureView() {
        addSubview(container)
        containerConstraints = container.pinToSuperviewEdges([.left, .right, .top, .bottom], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        container.addSubview(imageView)
        imageView.pinToSuperviewEdges([.left, .top], insets: .init(top: 20, left: 20, bottom: 0, right: 0))
        imageView.exactSize(.init(width: 20, height: 20))
        
        container.addSubview(label)
        label.pinToSuperviewEdges([.top, .right], insets: .init(top: 20, left: 0, bottom: 0, right: 20))
        label.leading(9, to: imageView)
        label.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -20).isActive = true
        let labelBottomContraint = label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        labelBottomContraint.priority = UILayoutPriority(600)
        labelBottomContraint.isActive = true
        
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        heightConstraint.priority = UILayoutPriority(900)
        heightConstraint.isActive = true
    }
    
    func update(
        text: String,
        image: AlertImage = .exclamationMark,
        containerInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    ) {
        self.update(text: text,
                    image: sfSymbol(image.rawValue, tintColor: .reversedBackground),
                    containerInsets: containerInsets)
    }
    
    func update(
        text: String,
        image: UIImage?,
        containerInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    ) {
        label.text = text
        imageView.image = image
        containerConstraints?.updateInsets(containerInsets)
    }
    
}
