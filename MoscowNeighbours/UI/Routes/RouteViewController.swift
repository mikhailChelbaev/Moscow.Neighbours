//
//  RouteViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//

import UIKit

extension RouteViewController.Settings {
    static let middleInsetFromBottomError: CGFloat = 350
    static let topInset: CGFloat = 10
    static let minimumFetchingDuration: Double = 1
}

final class RouteViewController: BottomSheetViewController, LoadingStatusProvider {
    
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
    
    private let headerView = HeaderView()
    
    // MARK: - internal properties
    
    var showRouteCompletion: ((Route) -> Void)?
    
    var status: LoadingStatus = .loading {
        didSet {
            if oldValue != status { changeStateSize() }
            tableView.reloadData()
        }
    }
    
    // MARK: - private properties
    
    private var routes: [Route] = []
    
    private let service = RoutesService()
    
    private var startFetchingDate: Date = .init()
    
    // MARK: - init
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {        
        tableView.successDataSource = self
        tableView.statusProvider = self
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        
        setUp(scrollView: tableView, headerView: headerView, topInsetPortrait: Settings.topInset)
        
        headerView.update(text: "Маршруты", showSeparator: false)
        
        tableView.register(RouteCell.self)
    }
    
    private func fetchData() {
        status = .loading
        startFetchingDate = .init()
        service.fetchRoutes() { [weak self] result in
            guard let self = self else { return }
            let remainingTime: Double = max(0, Settings.minimumFetchingDuration - Date().timeIntervalSince(self.startFetchingDate))
            DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) {
                switch result {
                case .success(let routes):
                    self.routes = routes
                    self.status = .success
                case .failure:
                    self.status = .error(DefaultEmptyStateProviders.mainError(action: {
                        self.fetchData()
                    }))
                }
            }
        }
    }
    
    private func changeStateSize() {
        switch status {
        case .success:
            drawerView.middlePosition = .fromBottom(Settings.middleInsetFromBottom)
            drawerView.availableStates = [.middle, .top]
        case .error:
            drawerView.middlePosition = .fromBottom(Settings.middleInsetFromBottomError)
            drawerView.availableStates = [.middle]
        default:
            break
        }
        drawerView.setState(.middle, animated: true)
    }
    
}

// MARK: - extension UITableViewDataSource

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
        showRouteCompletion?(routes[indexPath.item])
    }
    
}

extension RouteViewController {
    
    private func createRouteCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.view.route = routes[indexPath.item]
        return cell
    }
    
}
