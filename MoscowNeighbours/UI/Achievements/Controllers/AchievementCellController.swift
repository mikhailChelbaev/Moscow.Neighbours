//
//  AchievementCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.05.2022.
//

import UIKit

final class AchievementCellController: CollectionCellController {
    private let viewModel: AchievementViewModel

    init(viewModel: AchievementViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AchievementCell.self, for: indexPath)
        
        let view = cell.view
        view.loader.startAnimating()
        view.titleLabel.text = "route name that will be on 2 lines"
        view.dateLabel.text = "10/20/2020"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionCrossDissolve]) {
                view.loader.stopAnimating()
                view.imageView.image = UIImage(named: "achievement")
            }
        }
        
        return cell
    }
}

extension AchievementCellController: SelectableCellController {
    func didSelect() {
        viewModel.onCellTap()
    }
}
