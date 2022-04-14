//
//  TextHeaderCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import UIKit

final class TextHeaderCellController: HeaderFooterController {
    private let viewModel: TextHeaderCellViewModel
    
    init(viewModel: TextHeaderCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UIView {
        let cell = TextCell()
        cell.update(
            text: viewModel.text,
            font: .mainFont(ofSize: 24, weight: .bold),
            insets: .init(top: 20, left: 20, bottom: 5, right: 20))
        return cell
    }
    
}
