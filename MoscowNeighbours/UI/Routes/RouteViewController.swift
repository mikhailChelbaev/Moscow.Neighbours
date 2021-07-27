//
//  RouteViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

final class RouteViewController: BottomSheetViewController {
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let headerView = HeaderView()
    
    // MARK: - internal properties
    
    var showRouteCompletion: ((Route) -> Void)?
    
    // MARK: - private properties
    
    private let routes: [Route] = data
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    
    private func commonInit() {        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        setUp(scrollView: tableView, headerView: headerView)
        
        headerView.update(text: "Маршруты", showSeparator: false)
        
        tableView.register(RouteCell.self)
    }
}

// MARK: - extension UITableViewDataSource

extension RouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.configureView = { [weak self] view in
            guard let `self` = self else { return }
            view.update(with: self.routes[indexPath.item])
        }
        return cell
    }
    
}

// MARK: - extension UITableViewDelegate

extension RouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showRouteCompletion?(routes[indexPath.item])
    }
    
}
