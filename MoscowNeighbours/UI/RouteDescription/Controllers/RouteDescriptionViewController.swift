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

public final class RouteDescriptionViewController: BottomSheetViewController {
    typealias Presenter = RouteDescriptionInput
    
    public let tableView: BaseTableView
    public let headerView: HandlerView
    
    private let presenter: Presenter
    private let tableViewController: RouteDescriptionTableViewController
    
    init(presenter: Presenter, tableViewController: RouteDescriptionTableViewController) {
        self.presenter = presenter
        self.tableViewController = tableViewController
        
        tableView = tableViewController.view
        headerView = HandlerView()
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didTransformRoute()
        configureBottomSheet()
    }
    
    private func configureBottomSheet() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
    }
    
    // MARK: - Get Bottom Sheet Components
    
    public override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    public override func getHeaderView() -> UIView? {
        return headerView
    }
    
    public override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(0),
                                        availableStates: [.top, .middle],
                                        cornerRadius: LegacyRouteHeaderCell.Layout.cornerRadius)
    }
}

