//
//  AuthorizationViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol AuthorizationView: BottomSheetViewController, LoadingStatusProvider {
    var type: AuthorizationType { set get }
    var signInButton: Button? { get }
    var signUpButton: Button? { get }
    
    func reloadData()
    func animateTypeChange()
}

class AuthorizationViewController: BottomSheetViewController, AuthorizationView {
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let buttonSide: CGFloat = 46
        static let cornerRadius: CGFloat = 29
    }
    
    // MARK: - Sections and Cells
    
    enum Sections: Int, CaseIterable {
        case switcher
        case inputs
    }
    
    enum SignInCells: Int, CaseIterable {
        case login
        case password
        case button
        case separator
        case appleButton
    }
    
    enum SignUpCells: Int, CaseIterable {
        case login
        case email
        case password
        case button
        case separator
        case appleButton
    }
    
    // MARK: - UI
    
    let tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .background
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    let headerView = HandlerView()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayBackground
        button.setImage(#imageLiteral(resourceName: "backButton").withTintColor(.reversedBackground, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        return button
    }()
    
    // MARK: - Internal properties
    
    let eventHandler: AuthorizationEventHandler
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
    var type: AuthorizationType = .signIn
    
    var signInButton: Button?
    var signUpButton: Button?
    
    // MARK: - Init
    
    init(eventHandler: AuthorizationEventHandler) {
        self.eventHandler = eventHandler
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        setUpViews()
        setUpLayout()
        setUpTableView()
        setUpKeyboardObservers()
    }
    
    // MARK: - Private methods
    
    private func setUpLayout() {
        bottomSheet.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    private func setUpTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        tableView.loadingDelegate = self
        
        tableView.register(AppIconCell.self)
        tableView.register(AuthorizationTypeCell.self)
        tableView.register(TextInputCell.self)
        tableView.register(ButtonCell.self)
        tableView.register(OrSeparatorCell.self)
        tableView.register(SignInWithAppleButtonCell.self)
    }
    
    private func setUpViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = Layout.cornerRadius
        tableView.clipsToBounds = true
        
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
                                        availableStates: [.top, .middle])
    }
    
    // MARK: - Handler back button
    
    @objc private func handleBackButton() {
        eventHandler.onBackButtonTap()
    }
    
    // MARK: - AuthorizationView
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func animateTypeChange() {
        let animation: UITableView.RowAnimation = type == .signIn ? .right : .left
        tableView.reloadSections(IndexSet(integer: Sections.inputs.rawValue), with: animation)
    }
            
}

// MARK: - protocol TableSuccessDataSource

extension AuthorizationViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else {
            fatalError("Section is out of bounds")
        }
        
        switch section {
        case .switcher:
            return 2
            
        case .inputs:
            return type == .signIn ? SignInCells.allCases.count : SignUpCells.allCases.count
        }
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Section is out of bounds")
        }
        
        switch section {
        case .switcher:
            if indexPath.item == 0 {
                return createAppIconCell(for: indexPath)
                
            } else {
                return createAuthorizationTypeCell(for: indexPath)
            }
            
        case .inputs:
            if type == .signIn {
                return createSignInSectionCell(for: indexPath)
                
            } else {
                return createSignUpSectionCell(for: indexPath)
            }
        }
        
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - protocol LoadingDelegate

extension AuthorizationViewController: LoadingDelegate {
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle)
    }
}

// MARK: - Sections Creation

extension AuthorizationViewController {
    private func createSignInSectionCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = SignInCells(rawValue: indexPath.item) else {
            fatalError("Row is out of bounds")
        }
        
        switch cell {
        case .login:
            return createTextInputCell(headerText: "Эл. почта / Логин",
                                       text: eventHandler.signInUsername,
                                       placeholder: "Введите эл. почту / логин",
                                       textContentType: .username,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onSignInUsernameTextChange(newText)
            },
                                       for: indexPath)
            
        case .password:
            return createTextInputCell(headerText: "Пароль",
                                       text: eventHandler.signInPassword,
                                       placeholder: "Введите пароль",
                                       textContentType: .password,
                                       isSecureTextEntry: true,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onSignInPasswordTextChange(newText)
            },
                                       for: indexPath)
            
        case .button:
            return createSignInButtonCell(for: indexPath)
            
        case .separator:
            return createSeparatorCell(for: indexPath)
            
        case .appleButton:
            return createSignInWithAppleButton(for: indexPath)
        }
    }
    
    private func createSignUpSectionCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = SignUpCells(rawValue: indexPath.item) else {
            fatalError("Row is out of bounds")
        }
        
        switch cell {
        case .login:
            return createTextInputCell(headerText: "Логин",
                                       text: eventHandler.signUpUsername,
                                       placeholder: "Введите логин",
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onSignUpUsernameTextChange(newText)
            },
                                       for: indexPath)
        case .email:
            return createTextInputCell(headerText: "Эл. почта",
                                       text: eventHandler.signUpEmail,
                                       placeholder: "Введите эл. почту",
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onSignUpEmailTextChange(newText)
            },
                                       for: indexPath)
            
        case .password:
            return createTextInputCell(headerText: "Пароль",
                                       text: eventHandler.signUpPassword,
                                       placeholder: "Введите пароль",
                                       textContentType: .password,
                                       isSecureTextEntry: true,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.onSignUpPasswordTextChange(newText)
            },
                                       for: indexPath)
            
        case .button:
            return createSignUpButtonCell(for: indexPath)
            
        case .separator:
            return createSeparatorCell(for: indexPath)
            
        case .appleButton:
            return createSignInWithAppleButton(for: indexPath)
        }
    }
}

// MARK: - Cells Creations

extension AuthorizationViewController {
    private func createAppIconCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AppIconCell.self, for: indexPath)
        return cell
    }
    
    private func createAuthorizationTypeCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AuthorizationTypeCell.self, for: indexPath)
        cell.view.authorizationTypeDidChange = { [weak self] newValue in
            self?.eventHandler.onAuthorizationTypeTap(newValue)
        }
        return cell
    }
    
    private func createTextInputCell(headerText: String,
                                     text: String,
                                     placeholder: String,
                                     keyboardType: UIKeyboardType = .default,
                                     textContentType: UITextContentType? = nil,
                                     isSecureTextEntry: Bool = false,
                                     textDidChange: ((String) -> Void)?,
                                     for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextInputCell.self, for: indexPath)
        cell.view.update(headerText: headerText,
                         text: text,
                         placeholder: placeholder,
                         keyboardType: keyboardType,
                         textContentType: textContentType,
                         isSecureTextEntry: isSecureTextEntry,
                         textDidChange: textDidChange)
        return cell
    }
    
    private func createButtonCell(text: String,
                                  isEnabled: Bool,
                                  action: Action?,
                                  for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
        cell.view.update(title: text,
                         insets: .init(top: 25, left: 20, bottom: 20, right: 20),
                         color: .projectRed,
                         roundedCorners: true,
                         height: 42,
                         action: action)
        cell.view.button.isEnabled = isEnabled
        return cell
    }
    
    private func createSeparatorCell(for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(OrSeparatorCell.self, for: indexPath)
    }
    
    private func createSignInWithAppleButton(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SignInWithAppleButtonCell.self, for: indexPath)
        cell.view.onSignInWithAppleButtonTap = { [weak self] in
            self?.eventHandler.onSignInWithAppleButtonTap()
        }
        return cell
    }
    
    private func createSignInButtonCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = createButtonCell(text: "Войти в аккаунт",
                                    isEnabled: eventHandler.isSignInButtonEnabled,
                                action: { [weak self] in
            self?.eventHandler.onSignInButtonTap()
        },
                                for: indexPath)
        signInButton = (cell as? TableCellWrapper<ButtonCell>)?.view.button
        return cell
    }
    
    private func createSignUpButtonCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = createButtonCell(text: "Создать аккаунт",
                                    isEnabled: eventHandler.isSignUpButtonEnabled,
                                action: { [weak self] in
            self?.eventHandler.onSignUpButtonTap()
        },
                                for: indexPath)
        signUpButton = (cell as? TableCellWrapper<ButtonCell>)?.view.button
        return cell
    }
}

// MARK: - Handle Keyboard

extension AuthorizationViewController {
    
    private func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomInset = keyboardSize.height + view.safeAreaInsets.bottom
            tableView.contentInset = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
    }
    
    @objc private func keyboardWillHide() {
        tableView.contentInset = .zero
    }
    
}
