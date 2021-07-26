//
//  UITableView+Reuse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

extension UITableView {
    
    enum ElementKind {
        case headerOrFooter, cell
    }
    
    func register<T: CellView>(_ type: T.Type, kind: ElementKind = .cell) {
        if kind == .cell {
            self.register(TableCellWrapper<T>.self, forCellReuseIdentifier: T.reuseId)
        } else {
            self.register(TableViewHeaderFooterViewWrapper<T>.self, forHeaderFooterViewReuseIdentifier: T.reuseId)
        }
    }
    
    func dequeue<T: CellView>(_ type: T.Type, for indexPath: IndexPath) -> TableCellWrapper<T> {
        dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! TableCellWrapper<T>
    }
    
    func dequeue<T: CellView>(_ type: T.Type, kind: ElementKind) -> TableViewHeaderFooterViewWrapper<T> {
        if kind == .cell {
            fatalError("Only header and footer can be dequeued with parameter kind")
        } else {
            return dequeueReusableHeaderFooterView(withIdentifier: T.reuseId) as! TableViewHeaderFooterViewWrapper<T>
        }
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.section == numberOfSections - 1 && indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}

