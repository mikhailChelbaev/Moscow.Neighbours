//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit
import UltraDrawerView

protocol RouteDescriptionView: BottomSheetViewController, LoadingStatusProvider {
    var route: RouteViewModel? { set get }
    
    @MainActor func reloadData()
}

final class RouteDescriptionViewController: BottomSheetViewController, RouteDescriptionView {
    
    // MARK: - Sections
    
    enum Sections: Int, CaseIterable {
        case header
        case information
        case persons
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
    
    var route: RouteViewModel?
    
    let eventHandler: RouteDescriptionEventHandler
    
    var status: LoadingStatus = .loading {
        didSet { reloadData() }
    }
    
    // MARK: - init
    
    init(eventHandler: RouteDescriptionEventHandler) {
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
        
        eventHandler.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.updateShadowPath()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        eventHandler.onTraitCollectionDidChange(route: route)
    }
    
    // MARK: - RouteDescriptionView
    
    func reloadData() {
        tableView.reloadData()
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
                                        cornerRadius: RouteHeaderCell.Layout.cornerRadius)
    }
    
    // MARK: - Private methods
    
    private func setUpViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.containerView.clipsToBounds = true
        
        tableView.layer.cornerRadius = RouteHeaderCell.Layout.cornerRadius
        tableView.clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    private func setUpLayout() {
        bottomSheet.containerView.addSubview(backButton)
        backButton.leading(20)
        backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        backButton.exactSize(.init(width: Layout.buttonSide, height: Layout.buttonSide))
    }
    
    private func setUpTableView() {
        tableView.successDataSource = self
        tableView.loadingDelegate = self
        tableView.statusProvider = self
        
        tableView.register(RouteHeaderCell.self)
        tableView.register(TextCell.self)
        tableView.register(PersonCell.self)
        tableView.register(SeparatorCell.self)
    }
    
    // MARK: - Back button handler
    
    @objc private func handleBackButton() {
        eventHandler.onBackButtonTap()
    }
    
}

// MARK: - protocol TableSuccessDataSource

extension RouteDescriptionViewController: TableSuccessDataSource {
    
    func successNumberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else {
            fatalError("Section is out of bounds")
        }
        
        switch section {
        case .header:
            return 1
            
        case .information:
            return 3
            
        case .persons:
            return (route?.persons.count ?? 0) + 1
        }
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Section is out of bounds")
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
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Section is out of bounds")
        }
        guard let persons = route?.persons else {
            return
        }
        
        if case .persons = section, indexPath.item > 0 {
            eventHandler.onPersonCellTap(person: persons[indexPath.item - 1])
        }
    }
}

// MARK: - protocol LoadingDelegate

extension RouteDescriptionViewController: LoadingDelegate {
    func loadingTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - bottomSheet.origin(for: bottomSheet.state ?? .middle)
    }
}

// MARK: - extension Cells Creation

extension RouteDescriptionViewController {
    private func createRouteHeader(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteHeaderCell.self, for: indexPath)
        cell.view.route = route
        cell.view.beginRouteAction = { [weak self] in
            guard let `self` = self else { return }
            self.eventHandler.onBeginRouteButtonTap(route: self.route)
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
        cell.view.update(text: nil, attributedText: route?.description, insets: .init(top: 5, left: 20, bottom: 20, right: 20), lineHeightMultiple: 1.11)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createSeparatorCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func createPersonCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let persons = route?.persons else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeue(PersonCell.self, for: indexPath)
        let index = indexPath.item - 1
        
        cell.view.isFirst = index == 0
        cell.view.isLast = index == persons.count - 1
        // do not change order
        cell.view.person = persons[index]
        
        cell.selectionStyle = .none
        return cell
    }
}
