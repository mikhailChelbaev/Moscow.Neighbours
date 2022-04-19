//
//  PersonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

protocol PersonView: BottomSheetViewController, LoadingStatusProvider {
    var person: LegacyPersonViewModel { set get }
    var personPresentationState: PersonPresentationState { set get }
    
    func reloadData()
}

final class PersonViewController: BottomSheetViewController, PersonView {
    
    // MARK: - Sections
    
    enum ShortInfoSections: Int, CaseIterable {
        case header
        case description
        case information
        case alert
    }
    
    enum FullInfoSections: Int, CaseIterable {
        case header
        case information
        case description
        case readyToGo
    }
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let buttonSide: CGFloat = 46
    }
    
    // MARK: - UI
    
    let tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .background
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
    
    // MARK: - Internal properties
    
    let eventHandler: PersonEventHandler
    
    var person: LegacyPersonViewModel
    var personPresentationState: PersonPresentationState
    
    var status: LoadingStatus = .success {
        didSet { reloadData() }
    }
    
    // MARK: - Init
    
    init(eventHandler: PersonEventHandler) {
        self.eventHandler = eventHandler
        person = eventHandler.getPersonInfo()
        personPresentationState = eventHandler.getPersonPresentationState()
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayout()
        configureTableView()
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        eventHandler.onTraitCollectionDidChange()
    }
    
    func updatePerson(person: LegacyPersonViewModel,
                      personPresentationState: PersonPresentationState) {
        eventHandler.onPersonUpdate(person: person, personPresentationState: personPresentationState)
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
        tableView.successDataSource = self
        tableView.statusProvider = self
        tableView.loadingDelegate = self
        
        tableView.register(PersonHeaderCell.self)
        tableView.register(TextCell.self)
        tableView.register(SeparatorCell.self)
        tableView.register(AlertCell.self)
        tableView.register(PersonInfoBaseCell.self)
        tableView.register(PersonInfoCell.self)
        tableView.register(ButtonCell.self)
    }
    
    private func configureViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = PersonHeaderCell.Layout.cornerRadius
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
                                        availableStates: [.top, .middle],
                                        cornerRadius: PersonHeaderCell.Layout.cornerRadius)
    }
    
    // MARK: - Handler back button
    
    @objc private func handleBackButton() {
        eventHandler.onBackButtonTap()
    }
    
}

// MARK: - protocol TableSuccessDataSource

extension PersonViewController: TableSuccessDataSource {
    
    func successNumberOfSections(in tableView: UITableView) -> Int {
        switch personPresentationState {
        case .shortDescription:
            return ShortInfoSections.allCases.count
            
        case .fullDescription:
            return FullInfoSections.allCases.count
        }
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch personPresentationState {
        case .shortDescription:
            guard let section = ShortInfoSections(rawValue: section) else {
                fatalError("Section is out of bounds")
            }
            
            switch section {
            case .header:
                return 1
                
            case .description:
                return 3
                
            case .information:
                return 2
                
            case .alert:
                return 1
            }
            
        case .fullDescription:
            guard let section = FullInfoSections(rawValue: section) else {
                fatalError("Section is out of bounds")
            }
            
            switch section {
            case .header:
                return 1
                
            case .information:
                return 1
                
            case .description:
                return 1
                
            case .readyToGo:
                return 1
            }
        }
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch personPresentationState {
        case .shortDescription:
            guard let section = ShortInfoSections(rawValue: indexPath.section) else {
                fatalError("Section is out of bounds")
            }
            
            switch section {
            case .header:
                if indexPath.item == 0 {
                    return createPersonHeaderCell(person: person, for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .description:
                if indexPath.item == 0 {
                    return createTitleCell(text: "person.information".localized, for: indexPath)
                     
                } else if indexPath.item == 1 {
                    return createDescriptionCell(text: person.shortDescription,
                                                 for: indexPath)
                    
                } else if indexPath.item == 2 {
                    return createSeparatorCell(for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .information:
                if indexPath.item == 0 {
                    return createPersonInfoBaseCell(info: person.info, for: indexPath)
                     
                } else if indexPath.item == 1 {
                    return createSeparatorCell(for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .alert:
                if indexPath.item == 0 {
                    return createAlertCell(text: "person.pass_route_alert".localized,
                                           for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
            }
            
        case .fullDescription:
            guard let section = FullInfoSections(rawValue: indexPath.section) else {
                fatalError("Section is out of bounds")
            }
            
            switch section {
            case .header:
                if indexPath.item == 0 {
                    return createPersonHeaderCell(person: person, for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .information:
                if indexPath.item == 0 {
                    return createPersonInfoCell(info: person.info, for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .description:
                if indexPath.item == 0 {
                    return createDescriptionCell(text: person.fullDescription,
                                                 for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
                
            case .readyToGo:
                if indexPath.item == 0 {
                    return createButtonCell(text: "person.ready_to_go".localized, action: { [weak self] in
                        self?.handleBackButton()
                    }, for: indexPath)
                    
                } else {
                    fatalError("Row is out of bounds")
                }
            }
        }
    }
}

// MARK: - protocol LoadingDelegate

extension PersonViewController: LoadingDelegate {
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle)
    }
}

// MARK: - Cells Creation

extension PersonViewController {
    private func createPersonHeaderCell(person: LegacyPersonViewModel, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonHeaderCell.self, for: indexPath)
        cell.view.update(name: person.name,
                         imageUrl: person.avatarUrl)
        return cell
    }
    
    private func createTitleCell(text: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.view.update(text: text, font: .mainFont(ofSize: 24, weight: .bold), insets: .init(top: 20, left: 20, bottom: 5, right: 20))
        return cell
    }
    
    private func createDescriptionCell(text: NSAttributedString, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.view.update(text: nil, attributedText: text, insets: .init(top: 5, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
        return cell
    }
    
    private func createSeparatorCell(for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(SeparatorCell.self, for: indexPath)
    }
    
    private func createPersonInfoBaseCell(info: [ShortInfo], for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonInfoBaseCell.self, for: indexPath)
        cell.view.info = info
        return cell
    }
    
    private func createAlertCell(text: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AlertCell.self, for: indexPath)
        cell.view.update(text: text, containerInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
        return cell
    }
    
    private func createPersonInfoCell(info: [ShortInfo], for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonInfoCell.self, for: indexPath)
        cell.view.info = info
        return cell
    }
    
    private func createButtonCell(text: String,
                                  action: Action?,
                                  for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
        cell.view.update(title: text, roundedCorners: true, height: 42, action: action)
        return cell
    }
}

