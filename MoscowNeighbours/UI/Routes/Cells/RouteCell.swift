//
//  RouteCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 13.09.2021.
//

import UIKit
import ImageView

class RouteCell: CellView {
    
    var route: Route? {
        didSet { update() }
    }
    
    let containerView: ImageView = {
        let iv = ImageView()
        iv.backgroundColor = .imageBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .mainFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let gradientView: GradientView = {
        let view = GradientView()
        if let layer = view.layer as? CAGradientLayer {
            layer.colors = [
                UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
            ]
        }
        return view
    }()
    
//    let distanceInfo: InfoView = .init()
    
    let durationInfo: InfoView = .init()
    
    override func setUpView() {
        backgroundColor = .background
        clipsToBounds = false
        
        addSubview(containerView)
        containerView.stickToSuperviewEdges(.all, insets: .init(top: 5, left: 20, bottom: 5, right: 20))
        containerView.height(194)
        
        containerView.addSubview(gradientView)
        gradientView.stickToSuperviewEdges([.left, .bottom, .right])
        gradientView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.stickToSuperviewEdges([.left, .bottom, .right], insets: .init(top: 0, left: 20, bottom: 20, right: 20))
        
//        containerView.addSubview(distanceInfo)
//        distanceInfo.stickToSuperviewEdges([.left, .top], insets: .init(top: 20, left: 20, bottom: 0, right: 0))
        
//        containerView.addSubview(durationInfo)
//        durationInfo.leading(5, to: distanceInfo)
//        durationInfo.top(20)
        
        containerView.addSubview(durationInfo)
        durationInfo.stickToSuperviewEdges([.left, .top], insets: .init(top: 20, left: 20, bottom: 0, right: 0))
    }
    
    private func update() {
        guard let route = route else { return }
        
        containerView.loadImage(route.coverUrl)
        titleLabel.text = route.name
//        distanceInfo.update(text: "200 m", image: sfSymbol("location.fill", tintColor: .white))
        durationInfo.update(text: "\(route.distance) • \(route.duration)", image: nil)
    }
    
}
