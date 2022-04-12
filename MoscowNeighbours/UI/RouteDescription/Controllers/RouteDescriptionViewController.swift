//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

protocol RouteDescriptionInput {
    func didTransformRoute()
}

public final class RouteDescriptionViewController: UIViewController {
    typealias Presenter = RouteDescriptionInput
    
    public let tableView: BaseTableView
//    let headerView: HeaderView
    
    private let presenter: Presenter
    private let tableViewController: RouteDescriptionTableViewController
    
    init(presenter: Presenter, tableViewController: RouteDescriptionTableViewController) {
        self.presenter = presenter
        self.tableViewController = tableViewController
        
        tableView = tableViewController.view
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didTransformRoute()
    }
}
