//
//  PersonCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.07.2021.
//

import UIKit
import ImageView

final class PersonCell: CellView {
    
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
    
    let personContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .inversedBackground
        view.layer.cornerRadius = 18
        return view
    }()
    
    let houseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .reversedLabel
        return label
    }()
    
    let personAvatar: ImageView = {
        let iv = ImageView()
        iv.placeholder = .symbol(name: "person.crop.circle", tintColor: .white)
        iv.layer.cornerRadius = Layout.imageSize.height / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let routeLineImageView = UIImageView()
    
    var isFirst: Bool = false, isLast: Bool = false
    
    override func commonInit() {
        backgroundColor = .background
        
        addSubview(containerView)
        containerView.stickToSuperviewEdges([.left, .right, .top], insets: .init(top: 20, left: 40, bottom: 0, right: 20))
        containerView.height(Layout.containerHeight)
        
        addSubview(personContainerView)
        personContainerView.stickToSuperviewEdges([.left, .right, .bottom], insets: .init(top: 0, left: 40, bottom: 20, right: 20))
        personContainerView.top(-Layout.personContainerHeight / 2, to: containerView)
        personContainerView.height(Layout.personContainerHeight)
        
        containerView.addSubview(houseTitleLabel)
        houseTitleLabel.stickToSuperviewEdges([.left, .top, .right], insets: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        containerView.addSubview(addressLabel)
        addressLabel.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 20, bottom: 0, right: 20))
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
        routeLineImageView.stickToSuperviewEdges([.left, .top, .bottom], insets: .init(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        containerView.layer.borderColor = UIColor.separator.cgColor
        routeLineImageView.image = drawImage(withBegining: !isFirst, withEnding: !isLast)
    }
    
    private func drawImage(withBegining: Bool, withEnding: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: Layout.dotSide, height: Layout.totalHeight))
        return renderer.image { _ in
            UIColor.systemRed.setFill()
            UIBezierPath(ovalIn: .init(origin: .init(x: 0, y: Layout.dotTopInset), size: .init(width: Layout.dotSide, height: Layout.dotSide))).fill()
            
            let xOffset: CGFloat = (Layout.dotSide - Layout.dashWidth) / 2
            
            if withBegining {
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
    
    func update(personInfo: PersonInfo, isFirst: Bool, isLast: Bool) {
        let person = personInfo.person
        personNameLabel.text = person.name
        addressLabel.text = person.address
        houseTitleLabel.text = personInfo.place.name
        routeLineImageView.image = drawImage(withBegining: !isFirst, withEnding: !isLast)
        personAvatar.image = UIImage(data: person.image) ?? personAvatar.placeholder.image
        
        self.isFirst = isFirst
        self.isLast = isLast
        
//        subtitleLabel.text = person.address
//        self.number = number
//        numberImageView.image = drawImage()
    }
    
}
