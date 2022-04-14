//
//  SeparatorCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 14.04.2022.
//

import UIKit

final class SeparatorCellController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SeparatorCell.self, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

