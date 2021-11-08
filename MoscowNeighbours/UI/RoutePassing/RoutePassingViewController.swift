//
//  RoutePassingViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.09.2021.
//

import UIKit
import UltraDrawerView

final class RoutePassingViewController: BottomSheetViewController, PagerMediator {
    
    // MARK: - Layout
    
    enum Layout {
        static let cornerRadius: CGFloat = 22
        static var topInsetFromBottom: CGFloat {
            EndRouteButtonView.Settigns.totalHeight + RoutePointsCollectionCell.Layout.height + PageIndexCell.Layout.height
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
    
    // MARK: - internal properties
    
    var mapPresenter: MapPresentable?
    
    var scrollView: PagerPresentable?
    
    var pageIndicator: PagerPresentable?
    
    var closePersons: [PersonInfo] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - private properties
    
    private var route: Route?
    
    private var currentIndex: Int = 0
    
    // MARK: - init
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods
    
    func update(route: Route?) {
        self.route = route
        tableView.reloadData()
    }
    
    func pageDidChange(_ index: Int, source: PagerSource) {
        switch source {
        case .scrollView:
            pageIndicator?.changePage(newIndex: index, animated: true)
        case .pageIndicator:
            scrollView?.changePage(newIndex: index, animated: true)
        }
        currentIndex = index
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        setUpTableView()
        setUp(scrollView: tableView, headerView: headerView)
        drawerView.topPosition = .fromBottom(Layout.topInsetFromBottom, ignoresSafeArea: false)
        headerView.update { [weak self] _ in
            self?.stopRoute()
        } opendDrawerButtonAction: { [weak self] _ in
            self?.drawerView.setState(.top, animated: true, completion: nil)
        }
        
        drawerView.containerView.backgroundColor = .clear
        
        drawerView.cornerRadius = Layout.cornerRadius
        drawerView.containerView.clipsToBounds = true
        tableView.layer.cornerRadius = Layout.cornerRadius
        tableView.clipsToBounds = true
    }
    
    private func setUpTableView() {
//        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PageIndexCell.self)
        tableView.register(RoutePointsCollectionCell.self)
    }
    
    private func stopRoute() {
        let alertController = UIAlertController(title: "Подтвердите действие", message: "Вы уверены, что хотите закончить маршрут?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.mapPresenter?.endRoute()
        }
        let no = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(yes)
        alertController.addAction(no)
        present(alertController, animated: true, completion: nil)
    }
    
    func scrollToPerson(_ personInfo: PersonInfo) {
        if let index = route?.personsInfo.firstIndex(where: { $0 == personInfo }) {
            currentIndex = index
        }
        scrollView?.changePage(newIndex: currentIndex, animated: true)
        pageIndicator?.changePage(newIndex: currentIndex, animated: true)
        drawerView.setState(.top, animated: true, completion: nil)
    }
    
    // TODO: - fix
    func drawerView(didUpdateOrigin origin: CGFloat) {
//        let isOpenDrawerButtonHidden: Bool = origin < drawerView.origin(for: .bottom)
//        headerView.updateOpenDrawerButtonState(isHidden: isOpenDrawerButtonHidden)
    }
//
    func drawerView(didChangeState state: DrawerView.State?) {
//        headerView.updateOpenDrawerButtonState(isHidden: state == .top)
        if let state = state {
            headerView.changeViewState(state)
        }
    }
    
}

// MARK: - extension UITableViewDataSource

extension RoutePassingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeue(PageIndexCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                self.pageIndicator = view
                view.pagerDelegate = self
                view.update(numberOfPages: self.route?.personsInfo.count ?? 0)
            }
            return cell
        } else {
            let cell = tableView.dequeue(RoutePointsCollectionCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configureView = { [weak self] view in
                self?.scrollView = view
                view.pagerDelegate = self
                view.mapPresenter = self?.mapPresenter
                view.update(with: self?.route, closePersons: self?.closePersons ?? [])
            }
            return cell
        }
    }
    
}

// MARK: - extension UITableViewDelegate

//extension RoutePassingViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showRouteCompletion?(routes[indexPath.item])
//    }
//
//}

