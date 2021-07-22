//
//  RouteViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 21.07.2021.
//


import UIKit
import UltraDrawerView

final class RouteViewController: UIViewController {
    
    // MARK: - Settings

    private enum Settings {
        static let topInsetPortrait: CGFloat = 36
        static let topInsetLandscape: CGFloat = 20
        static let middleInsetFromBottom: CGFloat = 280
        static let headerHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.2
        static let shadowOffset = CGSize.zero
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - UI
    
    private let headerView = RouteHeaderView()
    
    private lazy var drawerView: DrawerView = {
        let drawer = DrawerView(scrollView: tableView, delegate: self, headerView: headerView)
        drawer.translatesAutoresizingMaskIntoConstraints = false
        drawer.middlePosition = .fromBottom(Settings.middleInsetFromBottom)
        drawer.cornerRadius = Settings.cornerRadius
        drawer.containerView.backgroundColor = .systemBackground
        drawer.layer.shadowRadius = Settings.shadowRadius
        drawer.layer.shadowOpacity = Settings.shadowOpacity
        drawer.layer.shadowOffset = Settings.shadowOffset
        return drawer
    }()
    
    // MARK: - private properties
    
    private let cellInfos = ShapeCell.makeDefaultInfos()
    
    private var isFirstLayout = true
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    // MARK: - internal methods
    
    override func loadView() {
        view = drawerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        
        drawerView.setState(.middle, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            updateLayoutWithCurrentOrientation()
            drawerView.setState(UIDevice.current.orientation.isLandscape ? .top : .middle, animated: false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let prevState = drawerView.state
        
        updateLayoutWithCurrentOrientation()
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            let newState: DrawerView.State = (prevState == .bottom) ? .bottom : .top
            self?.drawerView.setState(newState, animated: context.isAnimated)
        })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        portraitConstraints = [
            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
            drawerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        landscapeConstraints = [
            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
            drawerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawerView.widthAnchor.constraint(equalToConstant: 320),
        ]
        
        headerView.height(Settings.headerHeight)
        
        tableView.dataSource = self
        tableView.register(ShapeCell.self, forCellReuseIdentifier: "\(ShapeCell.self)")
    }
    
    private func updateLayoutWithCurrentOrientation() {
        let orientation = UIDevice.current.orientation
        
        if orientation.isLandscape {
            portraitConstraints.forEach { $0.isActive = false }
            landscapeConstraints.forEach { $0.isActive = true }
            drawerView.topPosition = .fromTop(Settings.topInsetLandscape)
            drawerView.availableStates = [.top, .bottom]
        } else if orientation.isPortrait {
            landscapeConstraints.forEach { $0.isActive = false }
            portraitConstraints.forEach { $0.isActive = true }
            drawerView.topPosition = .fromTop(Settings.topInsetPortrait)
            drawerView.availableStates = [.top, .middle, .bottom]
        }
    }

}

// MARK: - extension UITableViewDataSource

extension RouteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ShapeCell.self)", for: indexPath)
        
        if let cell = cell as? ShapeCell {
            cell.update(with: cellInfos[indexPath.row])
        }
        
        return cell
    }
    
}

// MARK: - extension UITableViewDelegate

extension RouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ShapeCell.Layout.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
