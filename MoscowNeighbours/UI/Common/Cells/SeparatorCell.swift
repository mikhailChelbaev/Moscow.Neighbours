//
//  SeparatorCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

final class SeparatorCell: CellView {
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    var viewConstraints: AnchoredConstraints?
    
    override func configureView() {
        addSubview(view)
        viewConstraints = view.pinToSuperviewEdges(.all, insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        height(0.5)
    }
    
    func update(insets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)) {
        viewConstraints?.updateInsets(insets)
        layoutIfNeeded()
    }
    
}
