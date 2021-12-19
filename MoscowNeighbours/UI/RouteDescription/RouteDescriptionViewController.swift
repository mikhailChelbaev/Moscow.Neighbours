//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit
import UltraDrawerView

final class RouteDescriptionViewController: BottomSheetViewController {
    
    // MARK: - Sections
    
    enum Sections: Int, CaseIterable {
        case header
        case information
        case persons
    }
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.reloadData()
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

// MARK: - protocol UITableViewDataSource

extension RouteDescriptionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else {
            fatalError("Sections out of bounds")
        }
        
        switch section {
        case .header:
            return 1
            
        case .information:
            return 3
            
        case .persons:
            return route.personsInfo.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Sections out of bounds")
        }
        
        switch section {
        case .header:
            return createRouteHeader(for: indexPath)
            
        case .information:
            if indexPath.item == 0 {
                return createTextHeaderCell(text: "Информация:", for: indexPath)
                
            } else if indexPath.item == 1 {
                return createRouteDescriptionCell(for: indexPath)
                
            } else {
                return createSeparatorCell(for: indexPath)
            }
            
        case .persons:
            if indexPath.item == 0 {
                return createTextHeaderCell(text: "Куда пойдем:", for: indexPath)
                
            } else {
                return createPersonCell(for: indexPath)
            }
        }
    }
    
}

// MARK: - protocol UITableViewDelegate

extension RouteDescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.item > 0 {
            mapPresenter?.mapView.selectAnnotation(route.personsInfo[indexPath.item - 1], animated: true)
        }
    }
}

// MARK: - extension Cells Creation

extension RouteDescriptionViewController {
    private func createRouteHeader(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteHeaderCell.self, for: indexPath)
        cell.view.route = route
        cell.view.beginRouteAction = { [weak self] in
            guard let `self` = self else { return }
            self.mapPresenter?.startRoute(self.route)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func createTextHeaderCell(text: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.view.update(text: text, font: .mainFont(ofSize: 24, weight: .bold), insets: .init(top: 20, left: 20, bottom: 5, right: 20))
        cell.selectionStyle = .none
        return cell
    }
    
    private func createRouteDescriptionCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.view.update(text: nil, attributedText: handleMarkdown(for: route.description), insets: .init(top: 5, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createSeparatorCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createPersonCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonCell.self, for: indexPath)
        let index = indexPath.item - 1
        
        cell.view.isFirst = index == 0
        cell.view.isLast = index == route.personsInfo.count - 1
        // do not change order
        cell.view.personInfo = route.personsInfo[index]
        
        cell.selectionStyle = .none
        return cell
    }
}
