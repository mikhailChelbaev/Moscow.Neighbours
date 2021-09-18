//
//  PersonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

final class PersonViewController: BottomSheetViewController {
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let topInset: CGFloat = 0
        static let buttonSide: CGFloat = 46
    }
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let headerView = HandlerView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.layer.cornerRadius = Layout.buttonSide / 2
        button.addShadow()
        return button
    }()
    
    // MARK: - private properties
    
    private var personInfo: PersonInfo = .dummy
    
    private var closeAction: Action?
    
    override init() {
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.addTarget(self, action: #selector(closeController), for: .touchUpInside)
        
        setUp(scrollView: tableView, headerView: headerView, topInsetPortrait: Layout.topInset)
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
    
    func update(_ info: PersonInfo, color: UIColor, closeAction: Action?) {
        self.personInfo = info
        self.closeAction = closeAction
        
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(PersonHeaderCell.self)
        tableView.register(TextCell.self)
        tableView.register(SeparatorCell.self)
        tableView.register(AlertCell.self)
        
        drawerView.containerView.backgroundColor = .clear
        
        drawerView.cornerRadius = PersonHeaderCell.Layout.cornerRadius
        drawerView.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = PersonHeaderCell.Layout.cornerRadius
        tableView.clipsToBounds = true
        
        drawerView.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    @objc private func closeController() {
        closeAction?()
    }
    
}

// MARK: - extension UITableViewDataSource

extension PersonViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 4][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(PersonHeaderCell.self, for: indexPath)
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                view.update(name: self.personInfo.person.name, image: #imageLiteral(resourceName: "nagibin_002"))
            }
            cell.selectionStyle = .none
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.configureView = { view in
                    view.update(text: "Информация:", font: .mainFont(ofSize: 24, weight: .bold), insets: .init(top: 20, left: 20, bottom: 5, right: 20))
                }
                cell.selectionStyle = .none
                return cell
            } else if indexPath.item == 1 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.configureView = { [weak self] view in
                    guard let `self` = self else { return }
                    view.update(text: self.personInfo.person.description, font: .mainFont(ofSize: 18, weight: .regular), textColor: .secondaryLabel, insets: .init(top: 5, left: 20, bottom: 20, right: 20))
                }
                cell.selectionStyle = .none
                return cell
            } else if indexPath.item == 2 {
                let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(AlertCell.self, for: indexPath)
                cell.configureView = { view in
                    view.update(text: "Чтобы узнать о человеке больше, пройдите маршрут", containerInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
                }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}

// MARK: - extension UITableViewDelegate

extension PersonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

