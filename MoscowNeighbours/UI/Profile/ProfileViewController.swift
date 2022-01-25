//
//  ProfileViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.01.2022.
//

import UIKit

protocol ProfileView: BottomSheetViewController {
    var userModel: UserModel? { set get }
}

class ProfileViewController: BottomSheetViewController, ProfileView {
    
    // MARK: - Sections and Cells
    
    enum SectionType {
        case header
    }
    
    enum CellType {
        case user
        case separator
        case information
//        case exit
    }
    
    // MARK: - Layout
    
    enum Layout {
        static let cornerRadius: CGFloat = 29
        static let buttonSide: CGFloat = 46
    }
    
    // MARK: - UI

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let headerView = HandlerView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        button.makeShadow()
        return button
    }()
    
    // MARK: - Internal Properties
    
    let eventHandler: ProfileEventHandler
    
    var userModel: UserModel?
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    // MARK: - Private Properties
    
    private let sections: [SectionType]
    
    // MARK: - Init
    
    init(eventHandler: ProfileEventHandler) {
        self.eventHandler = eventHandler
        sections = [.header]
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.onLoadData()
        
        configureLayout()
        configureViews()
        configureTableView()
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        bottomSheet.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        
        tableView.register(SeparatorCell.self)
        tableView.register(UserHeaderCell.self)
        tableView.register(ButtonCell.self)
        tableView.register(AccountAchievementsCell.self)
    }
    
    private func configureViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = Layout.cornerRadius
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(0),
                                        middleInset: .fromTop(0),
                                        availableStates: [.top, .middle],
                                        cornerRadius: Layout.cornerRadius)
    }
    
    // MARK: - Handler back button
    
    @objc private func handleBackButton() {
        eventHandler.onBackButtonTap()
    }
}

// MARK: - protocol UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getSectionItems(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(at: indexPath)
    }
}

// MARK: - Sections and Cells Helpers

extension ProfileViewController {
    
    private func getSectionItems(for section: Int) -> [CellType] {
        switch sections[section] {
        case .header:
//            return [.user, .exit, .separator, .information, .separator]
            return [.user]
        }
    }
    
    private func getCell(at indexPath: IndexPath) -> UITableViewCell {
        let cellType = getCellType(at: indexPath)
        
        switch cellType {
        case .separator:
            return createSeparator(for: indexPath)
            
        case .user:
            return createUserHeaderCell(for: indexPath)
            
        case .information:
            return createAccountAchievementsCell(for: indexPath)
            
//        case .exit:
//            return createButtonCell(title: "profile.exit".localized, action: { [weak self] in
//                self?.eventHandler.onExitButtonTap()
//            }, for: indexPath)
        }
    }
    
    private func getCellType(at indexPath: IndexPath) -> CellType {
        getSectionItems(for: indexPath.section)[indexPath.item]
    }
            
}

// MARK: - Cells Creations

extension ProfileViewController {
    private func createSeparator(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createUserHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserHeaderCell.self, for: indexPath)
        cell.view.usernameLabel.text = userModel?.name
        cell.view.emailLabel.text = userModel?.email
        cell.selectionStyle = .none
        return cell
    }
    
    private func createButtonCell(title: String,
                                  action: Action?,
                                  for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
        cell.view.update(title: title,
                         insets: .init(top: 0, left: 20, bottom: 20, right: 20),
                         height: 42,
                         action: action)
        return cell
    }
    
    private func createAccountAchievementsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AccountAchievementsCell.self, for: indexPath)
        cell.view.update(data: [
            .init(title: "-1", subtitle: "profile.finished_routes".localized),
            .init(title: "-1", subtitle: "profile.open_neighbours".localized)
        ])
        return cell
    }
}


