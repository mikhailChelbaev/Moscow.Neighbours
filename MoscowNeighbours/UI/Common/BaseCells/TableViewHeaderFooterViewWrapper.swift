//
//  TableViewHeaderFooterViewWrapper.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class TableViewHeaderFooterViewWrapper<T>: UITableViewHeaderFooterView where T: CellView {
    
    private let view: T
    
    var configureView: ((T) -> ())? {
        didSet {
            configureView?(view)
        }
    }
    
    override init(reuseIdentifier: String?) {
        view = T.init()
        super.init(reuseIdentifier: T.reuseId)
        setUpLayout()
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

