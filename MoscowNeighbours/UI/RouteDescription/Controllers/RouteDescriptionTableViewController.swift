//
//  RouteDescriptionTableViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

protocol HeaderFooterController {
    func view(in tableView: UITableView) -> UIView
}

protocol CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

struct TableSection {
    let header: HeaderFooterController?
    let footer: HeaderFooterController?
    let cells: [CellController]
    
    init(header: HeaderFooterController?, footer: HeaderFooterController?, cells: [CellController]) {
        self.header = header
        self.footer = footer
        self.cells = cells
    }
    
    init(cells: [CellController]) {
        self.header = nil
        self.footer = nil
        self.cells = cells
    }
}

final class RouteDescriptionTableViewController: LoadingStatusProvider {
    
    lazy var view: BaseTableView = {
        let view = BaseTableView()
        
        view.backgroundColor = .background
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.layer.cornerRadius = EntityHeaderCell.Layout.cornerRadius
        view.clipsToBounds = true
        
        view.successDataSource = self
        view.statusProvider = self
        
        view.register(RouteHeaderCell.self)
        view.register(TextCell.self)
        view.register(SeparatorCell.self)
        
        return view
    }()
    
    var tableModels: [TableSection]
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init() {
        tableModels = []
        status = .loading
    }
}

extension RouteDescriptionTableViewController: RouteDescriptionLoadingView {
    func display(isLoading: Bool) {
        if isLoading { status = .loading }
    }
}
 
extension RouteDescriptionTableViewController: TableSuccessDataSource {
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels[section].cells.count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModels[indexPath.section].cells[indexPath.row].view(in: tableView, indexPath: indexPath)
    }
    
    func successTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableModels[section].header?.view(in: tableView)
    }
}
