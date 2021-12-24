//
//  PersonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

protocol PersonView: BottomSheetViewController { }

final class PersonViewController: BottomSheetViewController, PersonView {
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let buttonSide: CGFloat = 46
    }
    
    // MARK: - UI
    
    let tableView: UITableView = {
        let tableView = UITableView()
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
    
    // MARK: - private properties
    
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        let parser = DefaultMarkdownParser()
        parser.configurator = config
        return parser
    }()
    
    // MARK: - internal properties
    
    let eventHandler: PersonEventHandler
    
    let personInfo: PersonInfo
    let userState: UserState
    
    // MARK: - init
    
    init(eventHandler: PersonEventHandler) {
        self.eventHandler = eventHandler
        personInfo = eventHandler.getPersonInfo()
        userState = eventHandler.getUserState()
        
        super.init()
        
        tableView.dataSource = self
        tableView.reloadData()
        
        backButton.addTarget(self, action: #selector(handlerBackButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        parser.clearCache()
        tableView.reloadData()
    }
    
    func update() {
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(PersonHeaderCell.self)
        tableView.register(TextCell.self)
        tableView.register(SeparatorCell.self)
        tableView.register(AlertCell.self)
        tableView.register(PersonInfoBaseCell.self)
        tableView.register(PersonInfoCell.self)
        tableView.register(ButtonCell.self)
        
        bottomSheet.containerView.backgroundColor = .clear
        
        bottomSheet.cornerRadius = PersonHeaderCell.Layout.cornerRadius
        bottomSheet.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = PersonHeaderCell.Layout.cornerRadius
        tableView.clipsToBounds = true
        
        bottomSheet.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    @objc private func handlerBackButton() {
        eventHandler.onBackButtonTap()
    }
    
    private func handleMarkdown(for text: String) -> NSAttributedString {
        return parser.parse(text: text)
    }
    
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(0),
                                        availableStates: [.top, .middle])
    }
    
}

// MARK: - extension UITableViewDataSource

extension PersonViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2//mapPresenter?.visitedPersons.contains(personInfo) == true ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (mapPresenter?.visitedPersons.contains(personInfo) == true ? [1, 3] : [1, 3, 3])[section]
        return [1, 3][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(PersonHeaderCell.self, for: indexPath)
            cell.view.update(name: personInfo.person.name,
                             imageUrl: personInfo.person.avatarUrl)
            cell.selectionStyle = .none
            return cell
        }
//        if mapPresenter?.visitedPersons.contains(personInfo) == true {
        if true {
            if indexPath.item == 0 {
                let cell = tableView.dequeue(PersonInfoCell.self, for: indexPath)
                cell.view.info = personInfo.person.info
                cell.selectionStyle = .none
                return cell
            } else if indexPath.item == 1 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.view.update(text: nil, attributedText: handleMarkdown(for: personInfo.person.description), insets: .init(top: 0, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
                cell.view.update(title: "Готов идти дальше", roundedCorners: true, height: 42) { [weak self] _ in
                    self?.handlerBackButton()
                }
                return cell
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.item == 0 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.view.update(text: "Информация:", font: .mainFont(ofSize: 24, weight: .bold), insets: .init(top: 20, left: 20, bottom: 5, right: 20))
                cell.selectionStyle = .none
                return cell
            } else if indexPath.item == 1 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.view.update(text: nil, attributedText: handleMarkdown(for: personInfo.person.shortDescription), insets: .init(top: 5, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if indexPath.item == 0 {
                let cell = tableView.dequeue(PersonInfoBaseCell.self, for: indexPath)
                cell.view.info = personInfo.person.info
                cell.selectionStyle = .none
                return cell
            } else if indexPath.item == 1 {
                let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(AlertCell.self, for: indexPath)
                let text: String = userState == .passingRoute ? "Чтобы начать знакомство, подойдите ближе к локации" : "Чтобы узнать о человеке больше, пройдите маршрут"
                cell.view.update(text: text, containerInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}

