//
//  RouteViewController+TestHelpers.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 09.04.2022.
//

import UIKit
@testable import MoscowNeighbours

extension RouteViewController {
    private var loader: LoadingCell? {
        let ds = tableView.dataSource
        
        guard ds!.tableView(tableView, numberOfRowsInSection: loaderIndexPath.section) > loaderIndexPath.row else {
            return nil
        }
        
        let cell = ds?.tableView(tableView, cellForRowAt: loaderIndexPath) as? TableCellWrapper<LoadingCell>
        return cell?.view
    }
    
    private var loaderIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    var isLoaderVisible: Bool {
        return loader != nil
    }
    
    func numberOfRenderedRouteViews() -> Int {
        return tableView.numberOfRows(inSection: routesSection)
    }
    
    func routeView(at row: Int) -> RouteCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: routesSection)
        let cell = ds?.tableView(tableView, cellForRowAt: index) as? TableCellWrapper<RouteCell>
        return cell?.view
    }
 
    private var routesSection: Int {
        return 0
    }
}
