//
//  UserHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.01.2022.
//

import UIKit
import ImageView

final class UserHeaderCell: CellView {
    
    enum Layout {
        static let imageViewSide: CGFloat = 98
        static let imageOverlaySide: CGFloat = imageViewSide + 10
    }
    
//    static let a = 3
//    static let b = a + 2
    
    private let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayBackground
        return view
    }()
    
    let imageView: ImageView = {
        let iv = ImageView()
        iv.placeholder = .symbol(name: "person.crop.circle",
                                 tintColor: .reversedBackground)
        iv.layer.cornerRadius = Layout.imageViewSide / 2
        return iv
    }()
    
    private let imageOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = Layout.imageOverlaySide / 2
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override func configureView() {
        backgroundColor = .background
        
        addSubview(bannerView)
        bannerView.pinToSuperviewEdges([.left, .right, .top])
        bannerView.height(88)
        
        addSubview(imageOverlay)
        imageOverlay.centerHorizontally(to: bannerView)
        imageOverlay.top(-Layout.imageOverlaySide / 2, to: bannerView)
        imageOverlay.exactSize(Layout.imageOverlaySide)
        
        imageOverlay.addSubview(imageView)
        imageView.placeInCenter()
        imageView.exactSize(Layout.imageViewSide)
        
        addSubview(usernameLabel)
        usernameLabel.top(17, to: imageOverlay)
        usernameLabel.pinToSuperviewEdges([.left, .right], constant: 20)
        
        addSubview(emailLabel)
        emailLabel.top(7, to: usernameLabel)
        emailLabel.pinToSuperviewEdges([.left, .right, .bottom], constant: 20)
    }
    
}
