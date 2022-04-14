//
//  RouteInformationCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import UIKit

final class RouteInformationCellController {
    private let viewModel: RouteInformationCellViewModel
    
    init(viewModel: RouteInformationCellViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: TextCell?
    
    private func configure() {
        view?.update(
            text: nil,
            attributedText: viewModel.text,
            insets: .init(top: 5, left: 20, bottom: 20, right: 20),
            lineHeightMultiple: 1.11)
    }
    
}

extension RouteInformationCellController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TextCell.self, for: indexPath)
        cell.selectionStyle = .none
        view = cell.view
        configure()
        return cell
    }
}
