//
//  AuthorizationViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol AuthorizationView: BottomSheetViewController, LoadingStatusProvider {
    var type: AuthorizationType { set get }
    
    func reloadData()
    func animateTypeChange()
    
    func updateSignUpError(_ error: SignUpErrorsModel)
    func updateSignInError(_ error: SignInErrorsModel)
    @MainActor func handleSignInError(_ error: NetworkError?)
    @MainActor func handleSignUpError(_ error: NetworkError?)
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
//        case separator
//        case appleButton
    }
    
    enum SignUpCells: Int, CaseIterable {
        case login
        case email
        case password
        case button
//        case separator
//        case appleButton
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
    
    var eventHandler: AuthorizationEventHandler
    
    override var backgroundDimStyle: BackgroundDimStyle {
        return .fullScreen
    }
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
    var type: AuthorizationType = .signIn
    
    var signInErrors: SignInErrorsModel = .init()
    var signUpErrors: SignUpErrorsModel = .init()
    
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
        tableView.errorDelegate = self
        
        tableView.register(AppIconCell.self)
        tableView.register(AuthorizationTypeCell.self)
        tableView.register(TextInputCell.self)
        tableView.register(ErrorTextInputCell.self)
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

// MARK: - Handle errors

extension AuthorizationViewController {
    func updateSignUpError(_ error: SignUpErrorsModel) {
        signUpErrors = error
    }
    
    func updateSignInError(_ error: SignInErrorsModel) {
        signInErrors = error
    }
    
    func handleSignUpError(_ error: NetworkError?) {
        guard let error = error else {
            return
        }
        
        if let errorType = error.description {
            var errorData: SignUpErrorsModel = .init()
            
            switch errorType {
            case .userExists:
                errorData.email = "auth.user_already_exists".localized
            
            default:
                break
            }
            
            signUpErrors = errorData
            status = .success
        } else {
            let completion: Action = {[weak self] in
                self?.signUpErrors = .init()
                self?.status = .success
            }
            status = .error(DefaultEmptyStateProviders.mainError(action: completion))
        }
    }
    
    func handleSignInError(_ error: NetworkError?) {
        guard let error = error else {
            return
        }
        
        if let errorType = error.description {
            var errorData: SignInErrorsModel = .init()
            
            switch errorType {
            case .userNotFound:
                errorData.email = "auth.user_not_found".localized
                
            case .wrongPassword:
                errorData.password = "auth.wrong_password".localized
            
            default:
                break
            }
            
            signInErrors = errorData
            status = .success
        } else {
            let completion: Action = {[weak self] in
                self?.signInErrors = .init()
                self?.status = .success
            }
            status = .error(DefaultEmptyStateProviders.mainError(action: completion))
        }
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

// MARK: - protocol ErrorDelegate && LoadingDelegate

extension AuthorizationViewController: ErrorDelegate, LoadingDelegate {
    func errorTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return visibleTableViewHeight()
    }
    
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return visibleTableViewHeight()
    }
    
    private func visibleTableViewHeight() -> CGFloat {
        max(UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle) - headerView.frame.height - view.safeAreaInsets.bottom, 0)
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
            return createTextInputCell(headerText: "signIn.email_title".localized,
                                       text: eventHandler.signInModel.username,
                                       placeholder: "signIn.email_placeholder".localized,
                                       textContentType: .username,
                                       error: signInErrors.email,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.signInModel.username = newText
            },
                                       for: indexPath)
            
        case .password:
            return createTextInputCell(headerText: "signIn.password_title".localized,
                                       text: eventHandler.signInModel.password,
                                       placeholder: "signIn.password_placeholder".localized,
                                       textContentType: .password,
                                       isSecureTextEntry: true,
                                       error: signInErrors.password,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.signInModel.password = newText
            },
                                       for: indexPath)
            
        case .button:
            return createSignInButtonCell(for: indexPath)
            
//        case .separator:
//            return createSeparatorCell(for: indexPath)
//
//        case .appleButton:
//            return createSignInWithAppleButton(for: indexPath)
        }
    }
    
    private func createSignUpSectionCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = SignUpCells(rawValue: indexPath.item) else {
            fatalError("Row is out of bounds")
        }
        
        switch cell {
        case .login:
            return createTextInputCell(headerText: "signUp.login_title".localized,
                                       text: eventHandler.signUpModel.username,
                                       placeholder: "signUp.login_placeholder".localized,
                                       error: signUpErrors.username,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.signUpModel.username = newText
            },
                                       for: indexPath)
        case .email:
            return createTextInputCell(headerText: "signUp.email_title".localized,
                                       text: eventHandler.signUpModel.email,
                                       placeholder: "signUp.email_placeholder".localized,
                                       error: signUpErrors.email,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.signUpModel.email = newText
            },
                                       for: indexPath)
            
        case .password:
            return createTextInputCell(headerText: "signUp.password_title".localized,
                                       text: eventHandler.signUpModel.password,
                                       placeholder: "signUp.password_placeholder".localized,
                                       textContentType: .password,
                                       isSecureTextEntry: true,
                                       error: signUpErrors.password,
                                       textDidChange: { [weak self] newText in
                self?.eventHandler.signUpModel.password = newText
            },
                                       for: indexPath)
            
        case .button:
            return createSignUpButtonCell(for: indexPath)
            
//        case .separator:
//            return createSeparatorCell(for: indexPath)
//            
//        case .appleButton:
//            return createSignInWithAppleButton(for: indexPath)
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
                             isSecureTextEntry: isSecureTextEntry,
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
                             isSecureTextEntry: isSecureTextEntry,
                             textDidChange: textDidChange)
            return cell
        }
    }
    
    private func createButtonCell(text: String,
                                  action: Action?,
                                  for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
        cell.view.update(title: text,
                         insets: .init(top: 25, left: 20, bottom: 20, right: 20),
                         color: .projectRed,
                         roundedCorners: true,
                         height: 42,
                         action: action)
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
        let cell = createButtonCell(text: "signIn.sign_in_button".localized,
                                    action: { [weak self] in
            self?.eventHandler.onSignInButtonTap()
        },
                                    for: indexPath)
        return cell
    }
    
    private func createSignUpButtonCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = createButtonCell(text: "signUp.sign_up_button".localized,
                                    action: { [weak self] in
            self?.eventHandler.onSignUpButtonTap()
        },
                                    for: indexPath)
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
