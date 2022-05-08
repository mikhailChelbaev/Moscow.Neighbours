//
//  BottomSheetController+IsLoaderVisible.swift
//  MoscowNeighboursTests
//
//  Created by Mikhail on 08.05.2022.
//

import MoscowNeighbours
import UIKit

extension BottomSheetViewController {
    
    private var loader: LoadingCell? {
        guard let tableView = getScrollView() as? UITableView else {
            return nil
        }
        
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
    
}
