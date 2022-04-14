//
//  PersonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import UIKit
import ImageView

public final class PersonCell: CellView {
    
    enum Layout {
        static let imageSize: CGSize = .init(width: 32, height: 32)
        static let containerHeight: CGFloat = 115
        static let personContainerHeight: CGFloat = 77
        static let dotTopInset: CGFloat = 109
        static let dotBottomInset: CGFloat = 75
        static let dotSide: CGFloat = 10
        static var totalHeight: CGFloat {
            dotTopInset + dotSide + dotBottomInset
        }
        static let dashWidth: CGFloat = 2
        static let dashHeight: CGFloat = 5
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        return view
    }()
    
    public let personContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .reversedBackground
        view.layer.cornerRadius = 18
        return view
    }()
    
    public let houseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    public let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    public let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .reversedLabel
        return label
    }()
    
    let personAvatar: ImageView = {
        let iv = ImageView()
        iv.placeholder = .symbol(name: "person.crop.circle", tintColor: .reversedLabel)
        iv.layer.cornerRadius = Layout.imageSize.height / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let routeLineImageView = UIImageView()
    
    var isFirst: Bool = false, isLast: Bool = false
    
    public override func configureView() {
        backgroundColor = .background
        
        addSubview(containerView)
        containerView.pinToSuperviewEdges([.left, .right, .top], insets: .init(top: 20, left: 40, bottom: 0, right: 20))
        containerView.height(Layout.containerHeight)
        
        addSubview(personContainerView)
        personContainerView.pinToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 40, bottom: 20, right: 20))
        personContainerView.top(-Layout.personContainerHeight / 2, to: containerView)
        personContainerView.height(Layout.personContainerHeight)
        
        containerView.addSubview(houseTitleLabel)
        houseTitleLabel.pinToSuperviewEdges([.left, .top, .right], insets: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        containerView.addSubview(addressLabel)
        addressLabel.pinToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        addressLabel.top(5, to: houseTitleLabel)
        
        personContainerView.addSubview(personAvatar)
        personAvatar.leading(16)
        personAvatar.exactSize(Layout.imageSize)
        personAvatar.centerVertically()
        
        personContainerView.addSubview(personNameLabel)
        personNameLabel.leading(6, to: personAvatar)
        personNameLabel.trailing(16)
        personNameLabel.centerVertically()
        
        addSubview(routeLineImageView)
        routeLineImageView.pinToSuperviewEdges([.left, .top, .bottom], insets: .init(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        containerView.layer.borderColor = UIColor.separator.cgColor
        routeLineImageView.image = drawImage(withBeginning: !isFirst, withEnding: !isLast)
    }
    
    func drawImage(withBeginning: Bool, withEnding: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: Layout.dotSide, height: Layout.totalHeight))
        return renderer.image { _ in
            UIColor.projectRed.setFill()
            UIBezierPath(ovalIn: .init(origin: .init(x: 0, y: Layout.dotTopInset), size: .init(width: Layout.dotSide, height: Layout.dotSide))).fill()
            
            let xOffset: CGFloat = (Layout.dotSide - Layout.dashWidth) / 2
            
            if withBeginning {
                var yOffset: CGFloat = 0
                
                while yOffset < Layout.dotTopInset {
                    UIColor.separator.setFill()
                    UIBezierPath(rect: .init(origin: .init(x: xOffset, y: yOffset), size: .init(width: Layout.dashWidth, height: Layout.dashHeight))).fill()
                    yOffset += 2 * Layout.dashHeight
                }
            }
            
            if withEnding {
                var yOffset: CGFloat = Layout.dotTopInset + Layout.dotSide + Layout.dashHeight
                
                while yOffset < Layout.totalHeight {
                    UIColor.separator.setFill()
                    UIBezierPath(rect: .init(origin: .init(x: xOffset, y: yOffset), size: .init(width: Layout.dashWidth, height: Layout.dashHeight))).fill()
                    yOffset += 2 * Layout.dashHeight
                }
            }

        }
    }
    
}

