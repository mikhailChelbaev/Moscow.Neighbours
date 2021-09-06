//
//  RouteDescriptionViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.07.2021.
//

import UIKit

final class RouteDescriptionViewController: BottomSheetViewController {
    
    // MARK: - State
    
    enum State {
        case `default`
        case routeInProgress
    }
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let headerView = HeaderView()
    
    // MARK: - internal properties
    
    weak var mapPresenter: MapPresentable?
    
    // MARK: - private properties
    
    private var route: Route = .dummy
    
    private var state: State = .default
    
    private var closeAction: Action?
    
    // MARK: - init
    
    override init() {
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUp(scrollView: tableView, headerView: headerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    func updateRoute(_ route: Route, closeAction: Action?) {
        self.route = route
        headerView.update(text: route.name, buttonCloseAction: closeAction)
        self.closeAction = closeAction
//        tableView.backgroundColor = route.color
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(RouteDescriptionCell.self)
        tableView.register(PersonCell.self)
        tableView.register(ButtonCell.self)
    }
}

// MARK: - extension UITableViewDataSource

extension RouteDescriptionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, route.personsInfo.count, 1][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue(RouteDescriptionCell.self, for: indexPath)
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                view.update(with: self.route)
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeue(PersonCell.self, for: indexPath)
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                view.update(person: self.route.personsInfo[indexPath.item].person, number: indexPath.item + 1)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
            var title: String
            var buttonColor: UIColor
            switch state  {
            case .default:
                title = "Пройти маршрут"
                buttonColor = route.color.value
            case .routeInProgress:
                title = "Завершить маршрут"
                buttonColor = .systemRed
            }
            cell.configureView = { [weak self] view in
                guard let `self` = self else { return }
                view.update(title: title, insets: .init(top: 40, left: 16, bottom: 10, right: 16), color: buttonColor) { button in
                    switch self.state {
                    case .default:
                        self.mapPresenter?.startRoute(self.route)
                        self.headerView.update(text: self.route.name, buttonCloseAction: nil)
                        self.state = .routeInProgress
                    case .routeInProgress:
                        self.mapPresenter?.endRoute()
                        self.headerView.update(text: self.route.name, buttonCloseAction: self.closeAction)
                        self.state = .default
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

// MARK: - extension UITableViewDelegate

extension RouteDescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            mapPresenter?.mapView.selectAnnotation(route.personsInfo[indexPath.item], animated: true)
        }
    }
    
}

