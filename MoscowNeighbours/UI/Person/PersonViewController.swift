//
//  PersonViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.08.2021.
//

import UIKit

final class PersonViewController: BottomSheetViewController {
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let headerView = HeaderView()
    
    // MARK: - private properties
    
    private var personInfo: PersonInfo = .dummy
    
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
    
    func update(_ info: PersonInfo, color: UIColor, closeAction: Action?) {
        self.personInfo = info
        headerView.update(text: info.person.name, buttonCloseAction: closeAction)
        tableView.backgroundColor = color
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func commonInit() {
        tableView.register(TextCell.self)
    }
}

// MARK: - extension UITableViewDataSource

extension PersonViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.configureView = { [weak self] view in
            view.update(text: self?.personInfo.person.description, backgroundColor: self?.tableView.backgroundColor ?? .systemBackground)
        }
        return cell
    }
    
}

// MARK: - extension UITableViewDelegate

extension PersonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

