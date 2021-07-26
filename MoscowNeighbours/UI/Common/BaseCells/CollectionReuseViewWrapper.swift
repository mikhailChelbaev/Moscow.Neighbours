//
//  CollectionReuseViewWrapper.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class CollectionReuseViewWrapper<T>: UICollectionReusableView where T: CellView {
    
    private let view: T
    
    var configureView: ((T) -> ())? {
        didSet {
            configureView?(view)
        }
    }
    
    override init(frame: CGRect) {
        view = T.init()
        super.init(frame: frame)
        setUpLayout()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayout() {
        addSubview(view)
        view.stickToSuperviewEdges([.left, .top])
        let const = view.bottom()
        const.priority = UILayoutPriority(999)
        let const2 = view.trailing()
        const2.priority = UILayoutPriority(999)
    }
    
}

