//
//  AccountConfirmationViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.01.2022.
//

import UIKit

protocol AccountConfirmationView: BottomSheetViewController {
    var viewData: AccountConfirmationViewData? { set get }
    
    func setStatus(_ loadingStatus: LoadingStatus)
}

class AccountConfirmationViewController: BottomSheetViewController, AccountConfirmationView, LoadingStatusProvider {
    
    // MARK: - Sections and Cells
    
    enum SectionType {
        case main
    }
    
    enum CellType {
        case alert
        case textField
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
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    let headerView = TitleHeaderView()
    
    let confirmButton: Button = {
        let button = Button()
        button.roundedCorners = true
        button.setTitle("confirm_account.confirm_button_title".localized, for: .normal)
        return button
    }()
    
    let changeAccountButton: Button = {
        let button = Button()
        button.overrideUserInterfaceStyle = .dark
        button.roundedCorners = true
        button.setTitle("confirm_account.change_account_button_title".localized, for: .normal)
        button.backgroundColor = .background
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    // MARK: - Internal properties
    
    let eventHandler: AccountConfirmationEventHandler
    
    var status: LoadingStatus = .loading
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    var viewData: AccountConfirmationViewData?
    
    // MARK: - Private Properties
    
    private let sections: [SectionType]
    
    // MARK: - Init
    
    init(eventHandler: AccountConfirmationEventHandler) {
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
        
        overrideUserInterfaceStyle = .dark
        
        configureViews()
        configureTableView()
        configureLayout()
        
        eventHandler.onViewLoad()
    }
    
    func setStatus(_ loadingStatus: LoadingStatus) {
        status = loadingStatus
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        tableView.errorDelegate = self
        tableView.loadingDelegate = self
        
        tableView.register(AlertCell.self)
        tableView.register(TextInputCell.self)
        tableView.register(ErrorTextInputCell.self)
    }
    
    private func configureViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        
        tableView.clipsToBounds = true
        
        confirmButton.action = { [weak self] in
            self?.eventHandler.onConfirmButtonTap()
        }
        changeAccountButton.action = { [weak self] in
            self?.eventHandler.onChangeAccountButtonTap()
        }
    }
    
    private func configureLayout() {
        let containerView = UIView()
        containerView.backgroundColor = .background
        
        containerView.addSubview(confirmButton)
        confirmButton.pinToSuperviewEdges([.left, .right, .top],
                                          insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        confirmButton.height(42)
        
        containerView.addSubview(changeAccountButton)
        changeAccountButton.pinToSuperviewEdges([.left, .right, .bottom],
                                          insets: .init(top: 0, left: 20, bottom: 0, right: 20))
        changeAccountButton.top(15, to: confirmButton)
        changeAccountButton.height(42)
        
        tableView.addSubview(containerView)
        containerView.pinToSuperviewSafeEdges([.left, .right, .bottom],
                                              insets: .init(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.title.text = "account_confirmation.title".localized
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

extension AccountConfirmationViewController: TableSuccessDataSource {
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

extension AccountConfirmationViewController: ErrorDelegate, LoadingDelegate {
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

extension AccountConfirmationViewController {
    
    private func getSectionItems(for section: Int) -> [CellType] {
        switch sections[section] {
        case .main:
            return [.alert, .textField]
        }
    }
    
    private func getCell(at indexPath: IndexPath) -> UITableViewCell {
        let cellType = getCellType(at: indexPath)
        
        switch cellType {
        case .alert:
            return createAlertCell(for: indexPath)
            
        case .textField:
            return createTextInputCell(headerText: "account_confirmation.text_field_title".localized,
                                       text: viewData?.code ?? "",
                                       placeholder: "account_confirmation.text_field_placeholder".localized,
                                       keyboardType: .numberPad,
                                       textContentType: .none,
                                       error: viewData?.code,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onCodeChange(newText)
            },
                                       for: indexPath)
        }
    }
    
    private func didTapOnCell(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getCellType(at indexPath: IndexPath) -> CellType {
        getSectionItems(for: indexPath.section)[indexPath.item]
    }
            
}


// MARK: - Cells Creations

extension AccountConfirmationViewController {
    private func createAlertCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AlertCell.self, for: indexPath)
        cell.view.update(text: "account_confirmation.alert_text".localized,
                         image: UIImage(named: "email"),
                         containerInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
        return cell
    }
    
    private func createTextInputCell(headerText: String,
                                     text: String,
                                     placeholder: String,
                                     keyboardType: UIKeyboardType = .default,
                                     textContentType: UITextContentType? = nil,
                                     error: String?,
                                     textDidChange: ((String) -> Void)?,
                                     for indexPath: IndexPath) -> UITableViewCell {
        if let error = error {
            let cell = tableView.dequeue(ErrorTextInputCell.self, for: indexPath)
            cell.view.update(headerText: headerText,
                             text: text,
                             placeholder: placeholder,
                             keyboardType: keyboardType,
                             textContentType: textContentType,
                             isSecureTextEntry: false,
                             error: error,
                             textDidChange: textDidChange)
            return cell
        } else {
            let cell = tableView.dequeue(TextInputCell.self, for: indexPath)
            cell.view.update(headerText: headerText,
                             text: text,
                             placeholder: placeholder,
                             keyboardType: keyboardType,
                             textContentType: textContentType,
                             isSecureTextEntry: false,
                             textDidChange: textDidChange)
            return cell
        }
    }
}




