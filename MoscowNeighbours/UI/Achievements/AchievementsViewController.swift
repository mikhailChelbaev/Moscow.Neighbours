//
//  AchievementsViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.01.2022.
//

import UIKit

enum AchievementsErrors: Int, CaseIterable {
    case main = 0
    case yana = 1
    case nikita = 2
    case misha = 3
    
    static var size: Int {
        Self.allCases.count
    }
}

protocol AchievementsView: BottomSheetViewController, LoadingStatusProvider {
    func updateErrorStatus(exact value: AchievementsErrors?)
}

class AchievementsViewController: BottomSheetViewController, AchievementsView {
    
    // MARK: - Sections and Cells
    
    enum SectionType {
        case main
    }
    
    enum CellType {
        case error
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
    
    let eventHandler: AchievementsEventHandler
    
    var status: LoadingStatus = .loading {
        didSet { tableView.reloadData() }
    }
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    // MARK: - Private Properties
    
    private let sections: [SectionType]
    
    // MARK: - Init
    
    init(eventHandler: AchievementsEventHandler) {
        self.eventHandler = eventHandler
        sections = [.main]
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureTableView()
        
        eventHandler.onLoadData()
    }
    
    func updateErrorStatus(exact value: AchievementsErrors? = nil) {
        let errorType: AchievementsErrors = value ?? AchievementsErrors(rawValue: Int.random(in: 0..<AchievementsErrors.size))!
        var dataProvider: EmptyStateDataProvider
        
        switch errorType {
        case .main:
            dataProvider = createMainError()
        case .yana:
            dataProvider = createYanaError()
        case .nikita:
            dataProvider = createNikitaError()
        case .misha:
            dataProvider = createMishaError()
        }
        
        status = .error(dataProvider)
        
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        tableView.errorDelegate = self
        tableView.loadingDelegate = self
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
        headerView.title.text = "achievements.title".localized
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

extension AchievementsViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return sections.count
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

// MARK: - protocol ErrorDelegate && LoadingDelegate

extension AchievementsViewController: ErrorDelegate, LoadingDelegate {
    func errorTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return visibleTableViewHeight()
    }
    
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return visibleTableViewHeight()
    }
    
    private func visibleTableViewHeight() -> CGFloat {
        UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle) - headerView.frame.height - view.safeAreaInsets.bottom
    }
}

// MARK: - Sections and Cells Helpers

extension AchievementsViewController {
    
    private func getSectionItems(for section: Int) -> [CellType] {
        switch sections[section] {
        case .main:
            return []
        }
    }
    
    private func getCell(at indexPath: IndexPath) -> UITableViewCell {
        let cellType = getCellType(at: indexPath)
        
        switch cellType {
        case .error:
            return UITableViewCell()
        }
    }
    
    private func didTapOnCell(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getCellType(at indexPath: IndexPath) -> CellType {
        getSectionItems(for: indexPath.section)[indexPath.item]
    }
            
}

// MARK: - Create Empty State

extension AchievementsViewController {
    func createErrorDataProvider(image: UIImage?, title: String) -> EmptyStateDataProvider {
        EmptyStateDataProvider(image: image,
                               title: title,
                               subtitle: nil,
                               buttonTitle: "achievements.error_button_title".localized,
                               imageHeight: 190,
                               buttonAction: { [weak self] in
            self?.eventHandler.onReloadButton()
        })
    }
    
    func createMainError() -> EmptyStateDataProvider {
        return createErrorDataProvider(image: UIImage(named: "achievements_main_error"),
                                       title: "achievements.error_main_title".localized)
    }
    
    func createYanaError() -> EmptyStateDataProvider {
        return createErrorDataProvider(image: UIImage(named: "achievements_yana_error"),
                                       title: "achievements.error_yana_title".localized)
    }
    
    func createNikitaError() -> EmptyStateDataProvider {
        return createErrorDataProvider(image: UIImage(named: "achievements_nikita_error"),
                                       title: "achievements.error_nikita_title".localized)
    }
    
    func createMishaError() -> EmptyStateDataProvider {
        return createErrorDataProvider(image: UIImage(named: "achievements_misha_error"),
                                       title: "achievements.error_misha_title".localized)
    }
}


// MARK: - Cells Creations

extension AchievementsViewController {
}



