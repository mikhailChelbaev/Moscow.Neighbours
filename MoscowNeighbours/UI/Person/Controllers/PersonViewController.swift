//
//  PersonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

protocol PersonInput {
    func didTransformPerson()
}

public final class PersonViewController: BottomSheetViewController {
    
    typealias Presenter = PersonInput
    
    // MARK: - UI
    
    public let tableView: BaseTableView
    public let headerView: HandlerView
    public let backButton: UIButton
    
    // MARK: - Private properties
    
    private let presenter: Presenter
    private let coordinator: PersonCoordinator
    private let tableViewController: PersonTableViewController
    private let backButtonController: BackButtonViewController
    
    // MARK: - Init
    
    init(presenter: Presenter,
         coordinator: PersonCoordinator,
         tableViewController: PersonTableViewController,
         backButtonController: BackButtonViewController) {
        self.presenter = presenter
        self.coordinator = coordinator
        self.tableViewController = tableViewController
        self.backButtonController = backButtonController
        
        tableView = tableViewController.view
        headerView = HandlerView()
        backButton = backButtonController.view()
        
        super.init()
        
        tableView.loadingDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didTransformPerson()
        configureBottomSheet()
        configureLayout()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        presenter.didTransformPerson()
    }
    
    // MARK: - Private methods
    
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
                                        cornerRadius: PersonHeaderCell.Layout.cornerRadius)
    }
    
}

// MARK: - protocol LoadingDelegate

extension PersonViewController: LoadingDelegate {
    public func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle)
    }
}
