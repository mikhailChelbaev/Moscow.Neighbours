//
//  PersonInfoCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.10.2021.
//

import UIKit

final class PersonInfoCell: PersonInfoBaseCell {
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .grayBackground
        view.layer.cornerRadius = 18
        return view
    }()
    
    override func setUpView() {
        addSubview(container)
        container.stickToSuperviewEdges(.all, insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        container.addSubview(stack)
        stack.stickToSuperviewEdges(.all, insets: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
}
