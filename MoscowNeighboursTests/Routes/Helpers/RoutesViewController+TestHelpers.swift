//
//  RoutesViewController+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import UIKit
@testable import MoscowNeighbours

extension RoutesViewController {
    
    // MARK: - Routes
    
    func numberOfRenderedRouteViews() -> Int {
        return tableView.numberOfRows(inSection: routesSection)
    }
    
    func routeView(at row: Int) -> RouteCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: routesSection)
        let cell = ds?.tableView(tableView, cellForRowAt: index) as? TableCellWrapper<RouteCell>
        return cell?.view
    }
    
    func simulateCellTap(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: routesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
 
    private var routesSection: Int {
        return 0
    }
    
    // MARK: - Error view
    
    private var errorView: EmptyStateCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: 0, section: errorViewSection)
        let cell = ds?.tableView(tableView, cellForRowAt: index) as? TableCellWrapper<EmptyStateCell>
        return cell?.view
    }
    
    private var errorViewSection: Int {
        return 0
    }
    
    func simulateErrorViewButtonTap() {
        errorView?.button.simulateTap()
    }
}
