//
//  PersonHeaderCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

final class PersonHeaderCellController {
    let viewModel: PersonHeaderCellViewModel
    
    init(viewModel: PersonHeaderCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: PersonHeaderCell?
    
    func configure() {
        view?.titleLabel.text = viewModel.name
        view?.imageView.loadImage(viewModel.avatarURL)
    }
}

extension PersonHeaderCellController: TableCellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonHeaderCell.self, for: indexPath)
        
        view = cell.view
        configure()
        
        return cell
    }
}
