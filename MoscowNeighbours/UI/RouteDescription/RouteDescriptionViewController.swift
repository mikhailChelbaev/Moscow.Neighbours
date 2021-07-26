//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit

final class RouteDescriptionViewController: BottomSheetViewController {
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let headerView = RouteHeaderView()
    
    // MARK: - private properties
    
    private var route: Route = .dummy
    
    override init() {
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUp(scrollView: tableView, headerView: headerView, states: [.dismissed, .middle, .top])
        drawerView.setState(.dismissed, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    func updateRoute(_ route: Route, closeAction: Action?) {
        self.route = route
        headerView.update(text: route.name, buttonCloseAction: closeAction)
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(RouteCell.self)
    }
}

// MARK: - extension UITableViewDataSource

extension RouteDescriptionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteCell.self, for: indexPath)
        cell.configureView = { [weak self] view in
            guard let `self` = self else { return }
            view.update(with: self.route)
        }
        return cell
    }
    
}

// MARK: - extension UITableViewDelegate

extension RouteDescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

