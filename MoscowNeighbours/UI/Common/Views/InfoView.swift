//
//  InfoView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.09.2021.
//

import UIKit

final class InfoView: UIVisualEffectView {
    
    enum Layout {
        static var height: CGFloat = 21
        static var imageMargin: CGFloat = 10
        static var labelMargin: CGFloat = 12
        static var spacing: CGFloat = 2
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    var imageViewLeadingConstraint: NSLayoutConstraint?
    
    var imageViewTrailingConstraint: NSLayoutConstraint?
    
    var titleLabelLeadingToViewConstraint: NSLayoutConstraint?
    
    var titleLabelLeadingToImageViewConstraint: NSLayoutConstraint?
    
    var titleLabelTrailingConstraint: NSLayoutConstraint?
    
    init() {
        let effect: UIVisualEffect = UIBlurEffect(style: .light)
        super.init(effect: effect)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        clipsToBounds = true
        contentView.layer.cornerRadius = Layout.height / 2
        layer.cornerRadius = Layout.height / 2
        
        contentView.addSubview(imageView)
        imageViewLeadingConstraint = imageView.leading(Layout.imageMargin)
        imageViewTrailingConstraint = imageView.trailing(Layout.imageMargin)
        imageView.exactSize(.init(width: 12, height: 12))
        imageView.centerVertically(-2)
        
        contentView.addSubview(titleLabel)
        titleLabelLeadingToViewConstraint = titleLabel.leading(Layout.labelMargin)
        titleLabelLeadingToImageViewConstraint = titleLabel.leading(Layout.spacing, to: imageView)
        titleLabelTrailingConstraint = titleLabel.trailing(Layout.labelMargin)
        titleLabel.centerVertically()
        
        height(Layout.height)
        
        imageViewTrailingConstraint?.isActive = false
        titleLabelLeadingToViewConstraint?.isActive = false
    }
    
    func update(text: String?, image: UIImage?) {
        titleLabel.text = text
        imageView.image = image
        
        func updateConstraints(active constraints: [NSLayoutConstraint?]) {
            let allConstaints: [NSLayoutConstraint?] = [
                imageViewLeadingConstraint,
                imageViewTrailingConstraint,
                titleLabelLeadingToViewConstraint,
                titleLabelLeadingToImageViewConstraint,
                titleLabelTrailingConstraint
            ]
            let shouldBeDeactivated: [NSLayoutConstraint] = allConstaints.filter({ !constraints.contains($0) }).compactMap({ $0 })
            NSLayoutConstraint.deactivate(shouldBeDeactivated)
            NSLayoutConstraint.activate(constraints.compactMap({ $0 }))
        }
        
        func deactivate(_ constraints: [NSLayoutConstraint?]) {
            NSLayoutConstraint.deactivate(constraints.compactMap({ $0 }))
        }
        
        if text != nil && image != nil {
            updateConstraints(active: [
                imageViewLeadingConstraint,
                titleLabelLeadingToImageViewConstraint,
                titleLabelTrailingConstraint
            ])
        } else if text != nil {
            updateConstraints(active: [
                titleLabelLeadingToViewConstraint,
                titleLabelTrailingConstraint
            ])
        } else {
            updateConstraints(active: [
                imageViewTrailingConstraint,
                imageViewTrailingConstraint
            ])
        }
    }
    
}
