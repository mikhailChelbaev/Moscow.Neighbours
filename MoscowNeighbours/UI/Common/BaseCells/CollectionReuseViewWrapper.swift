//
//  CollectionReuseViewWrapper.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class CollectionReuseViewWrapper<T>: UICollectionReusableView where T: CellView {
    let view: T
    
    override init(frame: CGRect) {
        view = T.init()
        super.init(frame: frame)
        setUpLayout()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayout() {
        addSubview(view)
        view.pinToSuperviewEdges([.left, .top])
        let const = view.bottom()
        const.priority = UILayoutPriority(999)
        let const2 = view.trailing()
        const2.priority = UILayoutPriority(999)
    }    
}

