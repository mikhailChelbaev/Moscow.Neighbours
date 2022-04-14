//
//  EntityHeaderCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 15.09.2021.
//

import UIKit
import ImageView

public class EntityHeaderCell: CellView {
    
    enum Layout {
        static var cornerRadius: CGFloat = 29
        static var height: CGFloat = 360
    }
    
    public var imageView: ImageView = {
        let iv = ImageView()
//        iv.placeholder = .image(#imageLiteral(resourceName: "route_placeholder"))
        iv.backgroundColor = .imageBackground
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = Layout.cornerRadius
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    internal var gradientView: GradientView = {
        let view = GradientView()
        view.layer.cornerRadius = Layout.cornerRadius
        return view
    }()
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    public override func configureView() {
        addSubview(imageView)
        imageView.pinToSuperviewEdges(.all)
        
        imageView.addSubview(gradientView)
        gradientView.pinToSuperviewEdges(.all)
        
        imageView.height(Layout.height)
    }
    
}
