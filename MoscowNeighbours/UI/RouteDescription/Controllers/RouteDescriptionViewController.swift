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
    public let backButton: UIButton
    
    private let presenter: Presenter
    private let coordinator: RouteDescriptionCoordinator
    private let tableViewController: RouteDescriptionTableViewController
    private let backButtonController: BackButtonViewController
    
    init(presenter: Presenter,
         coordinator: RouteDescriptionCoordinator,
         tableViewController: RouteDescriptionTableViewController,
         backButtonController: BackButtonViewController) {
        self.presenter = presenter
        self.coordinator = coordinator
        self.tableViewController = tableViewController
        self.backButtonController = backButtonController
        
        tableView = tableViewController.view
        headerView = HandlerView()
        backButton = backButtonController.view()
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didTransformRoute()
        configureBottomSheet()
        configureLayout()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        presenter.didTransformRoute()
    }
    
    private func configureBottomSheet() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
    }
    
    private func configureLayout() {
        bottomSheet.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: BackButtonViewController.Layout.buttonSide,
                                   height: BackButtonViewController.Layout.buttonSide))
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

