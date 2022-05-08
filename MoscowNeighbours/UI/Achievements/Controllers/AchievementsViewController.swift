//
//  AchievementsViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import UIKit

public final class AchievementsViewController: BottomSheetViewController {
    
    typealias Presenter = AchievementsPresenter
    
    public let tableView: BaseTableView
    public let headerView: TitleHeaderView
    
    private let presenter: Presenter
    private let tableViewController: AchievementsTableViewController
    
    init(presenter: Presenter, tableViewController: AchievementsTableViewController) {
        self.presenter = presenter
        
        tableView = tableViewController.view
        headerView = TitleHeaderView()
        
        self.tableViewController = tableViewController
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBottomSheet()
        
        presenter.didLoadHeader()
        presenter.didRequestAchievements()
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
        return BottomSheetConfiguration(
            topInset: .fromTop(0),
            middleInset: .fromTop(0),
            availableStates: [.top, .middle],
            cornerRadius: AchievementsTableViewController.Layout.cornerRadius)
    }
}

extension AchievementsViewController: AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel) {
        headerView.title.text = viewModel.title
    }
}
