//
//  UITableView+Reuse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

extension UITableView {
    
    func register<T: CellView>(_ type: T.Type) {
        register(TableCellWrapper<T>.self, forCellReuseIdentifier: T.reuseId)
    }
    
    func dequeue<T: CellView>(_ type: T.Type, for indexPath: IndexPath) -> TableCellWrapper<T> {
        dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! TableCellWrapper<T>
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.section == numberOfSections - 1 && indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}

