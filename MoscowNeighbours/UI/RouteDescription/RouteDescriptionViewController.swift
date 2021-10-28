//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit
import UltraDrawerView

final class RouteDescriptionViewController: BottomSheetViewController {
    
    // MARK: - Layout constraints
    
    enum Layout {
        static let topInset: CGFloat = 0
        static let buttonSide: CGFloat = 46
    }
    
    // MARK: - State
    
    enum State {
        case `default`
        case routeInProgress
    }
    
    // MARK: - UI
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
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
        button.makeShadow()
        return button
    }()
    
    // MARK: - internal properties
    
    weak var mapPresenter: MapPresentable?
    
    // MARK: - private properties
    
    private var route: Route = .dummy
    
    private var state: State = .default
    
    private var closeAction: Action?
    
    private let parser: MarkdownParser = {
        var config: MarkdownConfigurator = .default
        let parser = DefaultMarkdownParser()
        parser.configurator = config
        return parser
    }()
    
    // MARK: - init
    
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
    
    func updateRoute(_ route: Route, closeAction: Action?) {
        self.route = route
        self.closeAction = closeAction
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(RouteHeaderCell.self)
        tableView.register(TextCell.self)
        tableView.register(PersonCell.self)
        tableView.register(SeparatorCell.self)
        
        drawerView.containerView.backgroundColor = .clear
        
        drawerView.cornerRadius = RouteHeaderCell.Layout.cornerRadius
        drawerView.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = RouteHeaderCell.Layout.cornerRadius
        tableView.clipsToBounds = true
        
        drawerView.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    @objc private func closeController() {
        closeAction?()
    }
    
    private func handleMarkdown(for text: String) -> NSAttributedString {
        return parser.parse(text: text)
    }
    
}

// MARK: - extension UITableViewDataSource

extension RouteDescriptionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 3, route.personsInfo.count + 1][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(RouteHeaderCell.self, for: indexPath)
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                view.update(with: self.route) {
                    self.mapPresenter?.startRoute(self.route)
                }
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
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
                    let description = self.route.description
                    view.update(text: nil, attributedText: self.handleMarkdown(for: description), insets: .init(top: 5, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if indexPath.item == 0 {
                let cell = tableView.dequeue(TextCell.self, for: indexPath)
                cell.configureView = { view in
                    view.update(text: "Куда пойдем:", font: .mainFont(ofSize: 24, weight: .bold), insets: .init(top: 30, left: 20, bottom: 5, right: 20))
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeue(PersonCell.self, for: indexPath)
                cell.configureView = { [weak self] view in
                    guard let `self` = self else { return }
                    let index = indexPath.item - 1
                    let personInfo = self.route.personsInfo[index]
                    let isFirst = index == 0
                    let isLast = index == self.route.personsInfo.count - 1
                    view.update(personInfo: personInfo, isFirst: isFirst, isLast: isLast)
                }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}

// MARK: - extension UITableViewDelegate

extension RouteDescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.item > 0 {
            mapPresenter?.mapView.selectAnnotation(route.personsInfo[indexPath.item - 1], animated: true)
        }
    }
    
}

