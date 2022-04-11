//
//  RouteTableViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.04.2022.
//

import UIKit

final class RouteTableViewController: LoadingStatusProvider, RouteLoadingView {
    
    lazy var view: BaseTableView = {
        let view = BaseTableView()
        view.backgroundColor = .background
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        view.successDataSource = self
        view.statusProvider = self
        view.register(RouteCell.self)
        return view
    }()
    
    private var didRouteCellTap: (Route) -> Void
    
    private var tableModel: [RouteCellController]
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init(didRouteCellTap: @escaping (Route) -> Void) {
        self.didRouteCellTap = didRouteCellTap
        self.tableModel = []
        self.status = .loading
    }
    
    func display(isLoading: Bool) {
        if isLoading { status = .loading }
    }
    
    func display(tableModels: [RouteCellController]) {
        self.tableModel = tableModels
        status = .success
    }
    
    func display(error: Error, completion: @escaping () -> Void) {
        status = .error(DefaultEmptyStateProviders.mainError {
            completion()
        })
    }
}

// MARK: - protocol TableSuccessDataSource

extension RouteTableViewController: TableSuccessDataSource {
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView, indexPath: indexPath)
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = cellController(forRowAt: indexPath).model
        didRouteCellTap(route)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> RouteCellController {
        return tableModel[indexPath.item]
    }
}
