//
//  AchievementsTableViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit

final class AchievementsTableViewController: LoadingStatusProvider {
    
    public enum Layout {
        static let cornerRadius: CGFloat = 29
    }
    
    lazy var view: BaseTableView = {
        let view = BaseTableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .background
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.layer.cornerRadius = Layout.cornerRadius
        view.clipsToBounds = true
        
        view.successDataSource = self
        view.statusProvider = self
        
        return view
    }()
    
    var tableModels: [TableSection]
    var status: LoadingStatus {
        didSet { view.reloadData() }
    }
    
    init() {
        tableModels = []
        status = .success
    }
}

extension AchievementsTableViewController: AchievementsLoadingView {
    func display(isLoading: Bool) {
        if isLoading { status = .loading }
    }
}
 
extension AchievementsTableViewController: TableSuccessDataSource {
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
    
    func successTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableModels[indexPath.section].cells[indexPath.row] as? SelectableCellController)?.didSelect()
    }
}
