//
//  PersonInfoContainerCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

final class PersonInfoContainerCellController {
    let viewModel: PersonInfoCellViewModel
    
    init(viewModel: PersonInfoCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: PersonContainerInfoCell?
    
    func configure() {
        view?.update(with: viewModel.info)
    }
}

extension PersonInfoContainerCellController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonContainerInfoCell.self, for: indexPath)
        
        view = cell.view
        configure()
        
        return cell
    }
}
