//
//  TableCellWrapper.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

open class TableCellWrapper<T>: UITableViewCell where T: CellView {
    public let view: T
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        view = T.init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        backgroundColor = .clear
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayout() {
        contentView.addSubview(view)
        view.pinToSuperviewEdges([.top, .left])
        let const = view.bottom()
        const.priority = UILayoutPriority(999)
        let const2 = view.trailing()
        const2.priority = UILayoutPriority(1000)
    }
}

