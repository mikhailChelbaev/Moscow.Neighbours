//
//  RouteDescriptionHeaderViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

final class RouteDescriptionHeaderViewController {
    let viewModel: RouteDescriptionHeaderViewModel
    
    init(viewModel: RouteDescriptionHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    private var view: RouteHeaderCell?
    
    func configure() {
        view?.titleLabel.text = viewModel.title
        view?.routeInfo.update(text: viewModel.information, image: nil)
        view?.button.setTitle(viewModel.buttonTitle, for: .normal)
        view?.imageView.loadImage(viewModel.coverURL)
    }
}

extension RouteDescriptionHeaderViewController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteHeaderCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        view = cell.view
        configure()
        
        return cell
    }
}
