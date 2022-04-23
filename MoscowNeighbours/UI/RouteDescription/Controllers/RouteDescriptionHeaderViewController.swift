//
//  RouteDescriptionHeaderViewController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 12.04.2022.
//

import UIKit

final class RouteDescriptionHeaderViewController {
    let presenter: RouteDescriptionHeaderPresenter
    
    init(presenter: RouteDescriptionHeaderPresenter) {
        self.presenter = presenter
    }
    
    private var view: RouteHeaderCell?
}

extension RouteDescriptionHeaderViewController: CellController {
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteHeaderCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        view = cell.view
        presenter.didRequestData()
        
        return cell
    }
}
 
extension RouteDescriptionHeaderViewController: RouteDescriptionHeaderView {
    func display(_ viewModel: RouteDescriptionHeaderViewModel) {
        view?.titleLabel.text = viewModel.title
        view?.routeInfo.update(text: viewModel.information, image: nil)
        view?.imageView.loadImage(viewModel.coverURL)
        view?.button.setTitle(viewModel.buttonTitle, for: .normal)
        view?.button.action = viewModel.didTapButton
        view?.button.isEnabled = !viewModel.isLoading
        if viewModel.isLoading {
            view?.showActivityIndicator()
        }
    }
}
