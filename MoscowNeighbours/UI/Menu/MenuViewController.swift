//
//  MenuViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol MenuView: BottomSheetViewController, LoadingStatusProvider {
    func reloadData()
}

class MenuViewController: BottomSheetViewController, MenuView {
    
    // MARK: - Sections and Cells
    
    enum SectionType {
        case authorization
        case account
        case accountConfirmation
        case achievements
        case settings
        case logout
    }
    
    enum CellType {
        case authorization
        case account
        case separator
        case settings
        case achievements
        case accountConfirmation
        case logout
    }
    
    // MARK: - Layout
    
    enum Layout {
        static let cornerRadius: CGFloat = 29
    }
    
    // MARK: - UI
    
    let tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .background
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let headerView = TitleHeaderView()
    
    // MARK: - Internal properties
    
    let eventHandler: MenuEventHandler
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureTableView()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        
        tableView.register(AccountAdvantagesCell.self)
        tableView.register(MenuItemCell.self)
        tableView.register(SeparatorCell.self)
        tableView.register(UserAccountPreviewCell.self)
        tableView.register(AccountConfirmationNotificationCell.self)
        tableView.register(LogoutCell.self)
    }
    
    private func configureViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        
        tableView.clipsToBounds = true
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.title.text = "menu.title".localized
        headerView.backButtonAction = { [weak self] in
            self?.eventHandler.onBackButtonTap()
        }
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(0),
                                        middleInset: .fromTop(0),
                                        availableStates: [.top, .middle],
                                        cornerRadius: Layout.cornerRadius)
    }
            
}

// MARK: - protocol TableSuccessDataSource

extension MenuViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return getSections().count
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionItems(for: section).count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(at: indexPath)
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapOnCell(at: indexPath)
    }
}

// MARK: - Sections and Cells Helpers

extension MenuViewController {
    
    private func getSections() -> [SectionType] {
        if eventHandler.isUserAuthorized {
            if eventHandler.isUserVerified {
                return [.account, .achievements, .settings, .logout]
            } else {
                return [.accountConfirmation, .settings, .logout]
            }
        } else {
            return [.authorization, .settings]
        }
    }
    
    private func getSectionItems(for section: Int) -> [CellType] {
        let sections = getSections()
        switch sections[section] {
        case .authorization:
            return [.authorization, .separator]
        case .account:
            return [.account, .separator]
            
        case .accountConfirmation:
            return [.accountConfirmation, .separator]
            
        case .achievements:
            return [.achievements, .separator]
            
        case .settings:
            return [.settings, .separator]
            
        case .logout:
            return [.logout, .separator]
        }
    }
    
    private func getCell(at indexPath: IndexPath) -> UITableViewCell {
        let cellType = getCellType(at: indexPath)
        
        switch cellType {
        case .separator:
            return createSeparator(for: indexPath)
            
        case .authorization:
            return createAccountAdvantagesCell(for: indexPath)
            
        case .account:
            return createUserAccountPreviewCell(for: indexPath)
            
        case .settings:
            return createMenuItemCell(title: "menu.settings".localized,
                                      subtitle: "menu.settings_description".localized,
                                      for: indexPath)
            
        case .achievements:
            return createMenuItemCell(title: "menu.achievements".localized,
                                      subtitle: "menu.achievements_description".localized,
                                      for: indexPath)
            
        case .accountConfirmation:
            return createAccountConfirmationNotificationCell(for: indexPath)
            
        case .logout:
            return createLogoutCell(for: indexPath)
        }
    }
    
    private func didTapOnCell(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = getCellType(at: indexPath)        
        switch cell {
        case .settings:
            eventHandler.onSettingsCellTap()
            
//        case .account:
//            eventHandler.onAccountCellTap()
            
        case .achievements:
            eventHandler.onAchievementsCellTap()
            
        case .logout:
            eventHandler.onLogoutCellTap()
            
        default:
            break
        }
    }
    
    private func getCellType(at indexPath: IndexPath) -> CellType {
        getSectionItems(for: indexPath.section)[indexPath.item]
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
    
    private func createUserAccountPreviewCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserAccountPreviewCell.self, for: indexPath)
        cell.view.usernameLabel.text = eventHandler.username
        cell.view.emailLabel.text = eventHandler.email
//        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    private func createAccountConfirmationNotificationCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AccountConfirmationNotificationCell.self, for: indexPath)
        cell.view.buttonAction = { [weak self] in
            self?.eventHandler.onAccountConfirmationButtonTap()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func createLogoutCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LogoutCell.self, for: indexPath)
        return cell
    }
}
