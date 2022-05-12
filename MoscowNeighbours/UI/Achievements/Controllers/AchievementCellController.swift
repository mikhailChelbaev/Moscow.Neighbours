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
        view.titleLabel.text = viewModel.name
        view.dateLabel.text = viewModel.date
        view.imageView.loadImage(viewModel.imageURL) { [weak view] _ in
            view?.loader.stopAnimating()
        }
        
        return cell
    }
}

extension AchievementCellController: SelectableCellController {
    func didSelect() {
        viewModel.onCellTap()
    }
}
