//
//  MenuViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol MenuView: BottomSheetViewController, LoadingStatusProvider {
    
}

class MenuViewController: BottomSheetViewController, MenuView {
    
    // MARK: - UI
    
    let tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .background
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        return tableView
    }()
    
    let headerView = MenuHeaderView()
    
    // MARK: - Internal properties
    
    let eventHandler: MenuEventHandler
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
    // MARK: - Init
    
    init(eventHandler: MenuEventHandler) {
        self.eventHandler = eventHandler
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpLayout()
        setUpTableView()
        
        loadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        eventHandler.onLoadData()
    }
    
    private func setUpLayout() {
    }
    
    private func setUpTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        
        tableView.register(AccountAdvantagesCell.self)
        tableView.register(MenuItemCell.self)
        tableView.register(SeparatorCell.self)
    }
    
    private func setUpViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.backButtonAction = { [weak self] in
            self?.eventHandler.onBackButtonTap()
        }
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(0),
                                        middleInset: .fromTop(0),
                                        availableStates: [.top, .middle])
    }
    
    // MARK: - Cover Alpha
    
    override func recalculateCoverAlpha(for origin: CGFloat) {
        let bottom = view.frame.height
        let top = bottomSheet.origin(for: .top)
        cover.alpha = 0.7 * (origin - bottom) / (top - bottom)
    }
            
}

// MARK: - protocol TableSuccessDataSource

extension MenuViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            return createAccountAdvantagesCell(for: indexPath)

        } else if indexPath.item == 1 {
            return createSeparator(for: indexPath)

        } else if indexPath.item == 2 {
            return createMenuItemCell(title: "Настройки", subtitle: "Уведомления, язык и др.", for: indexPath)

        } else {
            return createSeparator(for: indexPath)
        }
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Cells Creations

extension MenuViewController {
    private func createAccountAdvantagesCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AccountAdvantagesCell.self, for: indexPath)
        cell.view.buttonAction = { [weak self] in
            self?.eventHandler.onAuthorizationButtonTap()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func createMenuItemCell(title: String,
                                    subtitle: String,
                                    for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MenuItemCell.self, for: indexPath)
        cell.view.title.text = title
        cell.view.subtitle.text = subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    private func createSeparator(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
