//
//  RoutePassingViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.09.2021.
//

import UIKit
import UltraDrawerView

protocol RoutePassingView: BottomSheetViewController {
    var selectedIndex: Int { set get }
    
    func reloadData()
}

final class RoutePassingViewController: BottomSheetViewController, RoutePassingView {
    
    // MARK: - Layout
    
    enum Layout {
        static let cornerRadius: CGFloat = 22
        static var topInsetFromBottom: CGFloat {
            EndRouteButtonView.Settings.totalHeight + RoutePointsCollectionCell.Layout.totalHeight
        }
    }
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let headerView = EndRouteButtonView()
    
    // MARK: - Internal properties
    
    let eventHandler: RoutePassingEventHandler
    
    var selectedIndex: Int = 0
    
    override var shouldDimBackground: Bool {
        false
    }
    
    // MARK: - Private properties
    
    private var route: RouteViewModel
    
    // MARK: - Init
    
    init(eventHandler: RoutePassingEventHandler) {
        self.eventHandler = eventHandler
        route = eventHandler.getRoute()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpViews()
        
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setUpViews() {
        bottomSheet.containerView.backgroundColor = .clear
        bottomSheet.cornerRadius = Layout.cornerRadius
        bottomSheet.containerView.clipsToBounds = true
        
        tableView.layer.cornerRadius = Layout.cornerRadius
        tableView.clipsToBounds = true
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        
        tableView.register(RoutePointsCollectionCell.self)
    }
    
    // MARK: - Bottom Sheet set up
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.update { [weak self] _ in
            self?.eventHandler.onEndRouteButtonTap()
        } arrowUpButtonAction: { [weak self] _ in
            self?.eventHandler.onArrowUpButtonTap()
        }
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromBottom(Layout.topInsetFromBottom, ignoresSafeArea: false),
                                        availableStates: [.top, .bottom])
    }
    
    override func drawerView(_ drawerView: DrawerView, didChangeState state: DrawerView.State?) {
        super.drawerView(drawerView, didChangeState: state)
        if let state = state {
            headerView.changeViewState(state)
        }
    }
    
}

// MARK: - extension UITableViewDataSource

extension RoutePassingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createRoutePointsCollectionCell(for: indexPath)
    }
}

// MARK: - Cells Creation

extension RoutePassingViewController {
    func createRoutePointsCollectionCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RoutePointsCollectionCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.view.update(route: route, currentIndex: selectedIndex) { [weak self] personInfo in
            self?.eventHandler.onBecomeAcquaintedButtonTap(personInfo)
        } indexDidChange: { [weak self] newIndex in
            self?.eventHandler.onIndexChange(newIndex)
        }
        return cell
    }
}

