//
//  RouteHeaderView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

final class RouteHeaderView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Маршруты"
        label.font = .mainFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.centerVertically()
        label.stickToSuperviewEdges([.left, .right], insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(separator)
        separator.stickToSuperviewEdges([.left, .right, .bottom])
        separator.height(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
