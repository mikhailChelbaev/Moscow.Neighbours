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

protocol SelectableCellController {
    func didSelect()
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
        let view = BaseTableView(frame: .zero, style: .grouped)
        
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
        view.register(PersonCell.self)
        
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
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return tableModels.count
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels[section].cells.count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModels[indexPath.section].cells[indexPath.row].view(in: tableView, indexPath: indexPath)
    }
    
    func successTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableModels[section].header?.view(in: tableView)
    }
    
    func successTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableModels[section].header == nil ? 0 : UITableView.automaticDimension
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableModels[indexPath.section].cells[indexPath.row] as? SelectableCellController)?.didSelect()
    }
}
