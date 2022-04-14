//
//  PersonCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import UIKit

final class PersonCellController {
    let viewModel: PersonCellViewModel
    
    init(viewModel: PersonCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: PersonCell?
    
    func configure() {
        view?.isFirst = viewModel.isFirst
        view?.isLast = viewModel.isLast       
        
        view?.personNameLabel.text = viewModel.name
        view?.addressLabel.text = viewModel.address
        view?.houseTitleLabel.text = viewModel.placeName
        view?.routeLineImageView.image = view?.drawImage(withBeginning: !viewModel.isFirst, withEnding: !viewModel.isLast)
        view?.personAvatar.loadImage(viewModel.avatarURL)
    }
}

extension PersonCellController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PersonCell.self, for: indexPath)
        view = cell.view
        configure()
        cell.selectionStyle = .none
        return cell
    }
}
