//
//  PersonTableViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

final class PersonTableViewController: LoadingStatusProvider {
    
    lazy var view: BaseTableView = {
        let view = BaseTableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .background
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.allowsSelection = false
        view.layer.cornerRadius = PersonHeaderCell.Layout.cornerRadius
        view.clipsToBounds = true
        
        view.successDataSource = self
        view.statusProvider = self
        
        view.register(PersonHeaderCell.self)
        view.register(TextCell.self)
        view.register(SeparatorCell.self)
        view.register(AlertCell.self)
        view.register(PersonInfoCell.self)
        view.register(PersonContainerInfoCell.self)
        view.register(ButtonCell.self)
        
        return view
    }()
    
    var tableModels: [TableSection]
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init() {
        tableModels = []
        status = .loading
    }
}

extension PersonTableViewController: PersonLoadingView {
    func display(isLoading: Bool) {
        if isLoading { status = .loading }
    }
}
 
extension PersonTableViewController: TableSuccessDataSource {
    func successNumberOfSections(in tableView: UITableView) -> Int {
        return tableModels.count
    }
    
    func successTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels[section].cells.count
    }
    
    func successTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModels[indexPath.section].cells[indexPath.row].view(in: tableView, indexPath: indexPath)
    }
    
    func successTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableModels[section].header?.view(in: tableView)
    }
    
    func successTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableModels[section].header == nil ? 0 : UITableView.automaticDimension
    }
}

