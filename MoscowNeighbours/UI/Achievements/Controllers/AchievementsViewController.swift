//
//  AchievementsViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import UIKit

public final class AchievementsViewController: BottomSheetViewController {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 29
    }
    
    typealias Presenter = AchievementsPresenter
    
//    public let tableView: BaseTableView
    public let headerView: TitleHeaderView
//    public let backButton: UIButton
    
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
        
//        tableView = tableViewController.view
        headerView = TitleHeaderView()
//        backButton = backButtonController.view()
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.didLoadHeader()
        
        configureBottomSheet()
        configureLayout()
    }
    
    private func configureBottomSheet() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
    }
    
    private func configureLayout() {
//        bottomSheet.containerView.addSubview(backButton)
//        backButton.leading(20)
//        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
//        backButton.exactSize(.init(width: BackButtonViewController.Layout.buttonSide,
//                                   height: BackButtonViewController.Layout.buttonSide))
    }
    
    // MARK: - Get Bottom Sheet Components
    
    public override func getScrollView() -> UIScrollView {
        return UITableView()
    }
    
    public override func getHeaderView() -> UIView? {
        return headerView
    }
    
    public override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(
            topInset: .fromTop(0),
            middleInset: .fromTop(0),
            availableStates: [.top, .middle],
            cornerRadius: Layout.cornerRadius)
    }
}

extension AchievementsViewController: AchievementsHeaderView {
    func display(_ viewModel: AchievementsHeaderViewModel) {
        headerView.title.text = viewModel.title
    }
}
