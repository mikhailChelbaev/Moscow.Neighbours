//
//  PersonInfoCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

final class PersonInfoCellController {
    let viewModel: PersonInfoCellViewModel
    
    init(viewModel: PersonInfoCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: PersonInfoCell?
    
    func configure() {
        view?.update(with: viewModel.info)
    }
}

extension PersonInfoCellController: TableCellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonInfoCell.self, for: indexPath)
        
        view = cell.view
        configure()
        
        return cell
    }
}

