//
//  RoutesViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

public final class RoutesViewController: BottomSheetViewController, RouteDescriptionPresenterView, RouteErrorView {
    
    // MARK: - UI
    
    let tableView: BaseTableView
    let headerView: HeaderView
    
    // MARK: - Properties
    
    private let presenter: RoutesPresenter
    private let tableViewController: RoutesTableViewController
    private let coordinator: RoutesCoordinator
    
    // MARK: - Init
    
    init(
        presenter: RoutesPresenter,
        tableViewController: RoutesTableViewController,
        coordinator: RoutesCoordinator) {
        self.presenter = presenter
        self.tableViewController = tableViewController
        self.coordinator = coordinator
        
        tableView = tableViewController.view
        headerView = HeaderView()
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didFetchRoutes()
    }
    
    func display(tableModels: [RouteCellController]) {
        tableViewController.display(tableModels: tableModels)
        
        let config = getBottomSheetConfiguration()
        bottomSheet.middlePosition = config.middleInset
        bottomSheet.availableStates = [.top, .middle, .bottom]
        bottomSheet.setState(.middle, animated: true)
    }
    
    func presentRouteDescription(for route: Route) {
        coordinator.displayRoute(route: route)
    }
    
    func display(error: Error) {
        tableViewController.display(error: error) { [weak self] in
            self?.presenter.didFetchRoutes()
        }
        
        bottomSheet.middlePosition = .fromBottom(350)
        bottomSheet.availableStates = [.middle, .bottom]
        bottomSheet.setState(.middle, animated: true)
    }
    
    public override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    public override func getHeaderView() -> UIView? {
        headerView.update(text: presenter.headerTitle, showSeparator: false)
        return headerView
    }
    
    public override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(10))
    }
    
    override func recalculateCoverAlpha(for origin: CGFloat) {
        if bottomSheet.availableStates.contains(.top) && bottomSheet.availableStates.contains(.middle) {
            let top = bottomSheet.origin(for: .top)
            let bottom = bottomSheet.origin(for: .middle)
            cover.alpha = 0.7 * (origin - bottom) / (top - bottom)
        }
        else {
            cover.alpha = 0
        }
    }
}
