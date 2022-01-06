//
//  SettingsViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 06.01.2022.
//

import UIKit

protocol SettingsView: BottomSheetViewController {
    
}

class SettingsViewController: BottomSheetViewController, SettingsView {
    
    // MARK: - Sections and Cells
    
    enum SectionType {
        case settings
    }
    
    enum CellType {
        case push
        case email
        case language
        case separator
    }
    
    // MARK: - UI
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        return tableView
    }()
    
    let headerView = MenuHeaderView()
    
    // MARK: - Internal Properties
    
    let eventHandler: SettingsEventHandler
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    // MARK: - Private Properties
    
    private let sections: [SectionType]
    
    // MARK: - Init
    
    init(eventHandler: SettingsEventHandler) {
        self.eventHandler = eventHandler
        sections = [.settings]
        
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
        
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ToggleSettingsCell.self)
        tableView.register(SeparatorCell.self)
        tableView.register(OneLineSettingsCell.self)
    }
    
    private func configureViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.title.text = "settings.title".localized
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
}

// MARK: - protocol UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
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

// MARK: - protocol SettingsViewController

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTapOnCell(at: indexPath)
    }
}

// MARK: - Sections and Cells Helpers

extension SettingsViewController {
    
    private func getSectionItems(for section: Int) -> [CellType] {
        switch sections[section] {
        case .settings:
            if eventHandler.isUserAuthorized {
                return [.push, .separator, .email, .separator, .language, .separator]
            } else {
                return [.push, .separator, .language, .separator]
            }
        }
    }
    
    private func getCell(at indexPath: IndexPath) -> UITableViewCell {
        let cellType = getCellType(at: indexPath)
        
        switch cellType {
        case .push:
            return createToggleSettingsCell(title: "settings.push_notifications_title".localized,
                                            subtitle: "settings.push_notifications_description".localized,
                                            isOn: eventHandler.isPushNotificationsEnabled,
                                            valueChanged: { [weak self] newValue in
                self?.eventHandler.onPushNotificationsValueChange(newValue)
            },
                                            for: indexPath)
            
        case .email:
            return createToggleSettingsCell(title: "settings.email_notifications_title".localized,
                                            subtitle: "settings.email_notifications_description".localized,
                                            isOn: eventHandler.isEmailNotificationsEnabled,
                                            valueChanged: { [weak self] newValue in
                self?.eventHandler.onEmailNotificationsValueChange(newValue)
            },
                                            for: indexPath)
            
        case .language:
            return createOneLineSettingsCell(title: "settings.language".localized, for: indexPath)
            
        case .separator:
            return createSeparator(for: indexPath)
        }
    }
    
    private func didTapOnCell(at indexPath: IndexPath) {
        let cell = getCellType(at: indexPath)
        
        switch cell {
        case .language:
            eventHandler.onLanguageButtonTap()
            
        default:
            break
        }
    }
    
    private func getCellType(at indexPath: IndexPath) -> CellType {
        getSectionItems(for: indexPath.section)[indexPath.item]
    }
            
}

// MARK: - Cells Creations

extension SettingsViewController {    
    private func createSeparator(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createToggleSettingsCell(title: String,
                                          subtitle: String,
                                          isOn: Bool,
                                          valueChanged: @escaping (Bool) -> Void,
                                          for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ToggleSettingsCell.self, for: indexPath)
        cell.view.title.text = title
        cell.view.subtitle.text = subtitle
        cell.view.toggle.isOn = isOn
        cell.view.valueChanged = valueChanged
        cell.selectionStyle = .none
        return cell
    }
    
    private func createOneLineSettingsCell(title: String,
                                           for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OneLineSettingsCell.self, for: indexPath)
        cell.view.title.text = title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

