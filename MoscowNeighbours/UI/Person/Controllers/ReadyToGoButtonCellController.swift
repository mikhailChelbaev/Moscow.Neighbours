//
//  ReadyToGoButtonCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

final class ReadyToGoButtonCellController {
    let viewModel: ReadyToGoButtonCellViewModel
    
    init(viewModel: ReadyToGoButtonCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: ButtonCell?
    
    func configure() {
        view?.update(
            title: viewModel.title,
            roundedCorners: true,
            height: 42,
            action: viewModel.action)
    }
}

extension ReadyToGoButtonCellController: TableCellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
        
        view = cell.view
        configure()
        
        return cell
    }
}

