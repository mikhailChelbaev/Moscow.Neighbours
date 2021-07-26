//
//  TableCellWrapper.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class TableCellWrapper<T>: UITableViewCell where T: CellView {
    private(set) var view: T
    
    var configureView: ((T) -> ())? {
        didSet {
            configureView?(view)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        view = T.init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayout() {
        contentView.addSubview(view)
        view.stickToSuperviewEdges([.top, .left])
        let const = view.bottom()
        const.priority = UILayoutPriority(999)
        let const2 = view.trailing()
        const2.priority = UILayoutPriority(1000)
    }
}

