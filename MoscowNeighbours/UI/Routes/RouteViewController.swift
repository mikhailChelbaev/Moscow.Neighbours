//
//  RouteViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

enum RouteDataState {
    case success(routes: [Route])
    case error(error: NetworkError)
}

protocol RouteView: BottomSheetViewController {
    var state: RouteDataState? { set get }
    
    func reloadData()
}

final class RouteViewController: BottomSheetViewController, LoadingStatusProvider, RouteView {
    
    // MARK: - Sections
    
    enum Sections: Int {
        case route = 0
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
    
    let headerView = HeaderView()
    
    // MARK: - Internal properties
    
    var showRouteCompletion: ((Route) -> Void)?
    
    var status: LoadingStatus = .loading {
        didSet {
            if oldValue != status { changeStateSize() }
            tableView.reloadData()
        }
    }
    
    // MARK: - private properties
    
    private var routes: [Route] = []
    
    let eventHandler: RoutesEventHandler
    
    var state: RouteDataState?
    
    // MARK: - Init
    
    init(eventHandler: RoutesEventHandler) {
        self.eventHandler = eventHandler
        super.init()
        setUpTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        status = .loading
        eventHandler.onFetchData()
    }
    
    func reloadData() {
        guard let state = state else {
            return
        }

        switch state {
        case .success(routes: let model):
            routes = model
            status = .success
            
        case .error:
            status = .error(DefaultEmptyStateProviders.mainError(action: { [weak self] in
                self?.fetchData()
            }))
        }
        
        changeStateSize()
        tableView.reloadData()
    }
    
    // MARK: - Get Bottom Sheet Components
    
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    override func getHeaderView() -> UIView? {
        headerView.update(text: "Маршруты", showSeparator: false)
        return headerView
    }
    
    override func getBottomSheetConfiguration() -> BottomSheetConfiguration {
        return BottomSheetConfiguration(topInset: .fromTop(10),
                                        availableStates: [.middle, .top])
    }
    
    // MARK: - Private methods
    
    private func setUpTableView() {
        tableView.successDataSource = self
        tableView.statusProvider = self
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        
        tableView.register(RouteCell.self)
    }
    
    private func changeStateSize() {
        let config = getBottomSheetConfiguration()
        switch status {
        case .success:
            bottomSheet.middlePosition = config.middleInset
            bottomSheet.availableStates = [.middle, .top]
        case .error:
            bottomSheet.middlePosition = .fromBottom(350)
            bottomSheet.availableStates = [.middle]
        default:
            break
        }
        bottomSheet.setState(.middle, animated: true)
    }
    
}

// MARK: - protocol UITableViewDataSource

extension RouteViewController: TableSuccessDataSource {
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Unexpected section value")
        }
        
        switch section {
        case .route:
            return createRouteCell(for: indexPath)
        }
    }
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler.onRouteCellTap(route: routes[indexPath.item])
    }
}

// MARK: - Cells Creation

extension RouteViewController {
    private func createRouteCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.view.route = routes[indexPath.item]
        return cell
    }
}
