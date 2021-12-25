//
//  EntityHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 15.09.2021.
//

import UIKit
import ImageView

class EntityHeaderCell: CellView {
    
    enum Layout {
        static var cornerRadius: CGFloat = 29
        static var height: CGFloat = 360
    }
    
    var imageView: ImageView = {
        let iv = ImageView()
//        iv.placeholder = .image(#imageLiteral(resourceName: "route_placeholder"))
        iv.backgroundColor = .imageBackground
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = Layout.cornerRadius
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var gradientView: GradientView = {
        let view = GradientView()
        view.layer.cornerRadius = Layout.cornerRadius
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func setUpView() {
        addSubview(imageView)
        imageView.stickToSuperviewEdges(.all)
        
        imageView.addSubview(gradientView)
        gradientView.stickToSuperviewEdges(.all)
        
        imageView.height(Layout.height)
    }
    
}
