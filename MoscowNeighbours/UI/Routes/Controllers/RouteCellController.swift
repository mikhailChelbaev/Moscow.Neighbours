//
//  RouteCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 11.04.2022.
//

import UIKit

final class RouteCellController {
    let model: Route
    
    init(model: Route) {
        self.model = model
    }
    
    private var view: RouteCell?
    
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RouteCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        view = cell.view
        configure()
        
        return cell
    }
    
    private func configure() {
        view?.containerView.loadImage(model.coverUrl)
        view?.titleLabel.text = model.name
        view?.infoView.update(text: "\(model.distance) • \(model.duration)", image: nil)
        view?.buyButton.setTitle(model.localizedPrice(), for: .normal)
        setViewButtonStyle(for: model.purchase.status)
    }
    
    private func setViewButtonStyle(for style: Purchase.Status) {
        switch style {
        case .free, .purchased:
            view?.buyButton.layer.borderWidth = 1
            view?.buyButton.layer.borderColor = UIColor.white.cgColor
            view?.buyButton.backgroundColor = .clear
            
        case .buy:
            view?.buyButton.layer.borderWidth = 0
            view?.buyButton.backgroundColor = .projectRed
        }
    }
}
