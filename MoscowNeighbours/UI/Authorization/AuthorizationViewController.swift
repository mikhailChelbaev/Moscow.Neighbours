//
//  AuthorizationViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 29.12.2021.
//

import UIKit

protocol AuthorizationView: BottomSheetViewController, LoadingStatusProvider {
    
}

class AuthorizationViewController: BottomSheetViewController, AuthorizationView {
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let buttonSide: CGFloat = 46
        static let cornerRadius: CGFloat = 29
    }
    
    // MARK: - UI
    
    let tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .black
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        return tableView
    }()
    
    let headerView = HandlerView()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        button.makeShadow()
        return button
    }()
    
    // MARK: - Internal properties
    
    let eventHandler: AuthorizationEventHandler
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
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
        
        setUpViews()
        setUpLayout()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    func reloadData() {
        tableView.reloadData()
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
    
    // MARK: - Cover Alpha
    
    override func recalculateCoverAlpha(for origin: CGFloat) {
        let bottom = view.frame.height
        let top = bottomSheet.origin(for: .top)
        cover.alpha = 0.7 * (origin - bottom) / (top - bottom)
    }
    
    // MARK: - Handler back button
    
    @objc private func handleBackButton() {
        eventHandler.onBackButtonTap()
    }
            
}

// MARK: - protocol TableSuccessDataSource

extension AuthorizationViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Cells Creations

extension AuthorizationViewController {
}

