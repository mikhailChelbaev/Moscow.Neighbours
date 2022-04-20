//
//  AlertCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 20.04.2022.
//

import UIKit

struct AlertCellViewModel {
    let text: String
    let image: AlertImage
}

final class AlertCellController {
    let viewModel: AlertCellViewModel
    
    init(viewModel: AlertCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: AlertCell?
    
    func configure() {
        view?.update(
            text: viewModel.text,
            image: viewModel.image,
            containerInsets: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
}

extension AlertCellController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AlertCell.self, for: indexPath)
        
        view = cell.view
        configure()
        
        return cell
    }
}

