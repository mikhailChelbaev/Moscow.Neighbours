//
//  RouteDescriptionTableViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

final class RouteDescriptionTableViewController: LoadingStatusProvider {
    
    lazy var view: BaseTableView = {
        let view = BaseTableView()
        view.successDataSource = self
        view.statusProvider = self
        return view
    }()
    
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init() {
        status = .loading
    }
}

extension RouteDescriptionTableViewController: RouteDescriptionLoadingView {
    func display(isLoading: Bool) {
        if isLoading { status = .loading }
    }
}

extension RouteDescriptionTableViewController: RouteDescriptionView {
    func display(route: RouteViewModel) {
        status = .success
    }
}
 
extension RouteDescriptionTableViewController: TableSuccessDataSource {
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
