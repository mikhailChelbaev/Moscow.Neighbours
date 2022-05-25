//
//  AchievementsCollectionCellController.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit

final class AchievementsCollectionCellController: NSObject, TableCellController {
    private let cellControllers: [CollectionCellController]

    init(viewModels: [AchievementViewModel]) {
        cellControllers = viewModels.map { AchievementCellController(viewModel: $0) }
    }
    
    func view(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AchievementsCollectionCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        let view = cell.view
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.collectionView.register(AchievementCell.self)
        view.updateCollectionHeight(heightForCollection())
        
        return cell
    }
}

extension AchievementsCollectionCellController {
    private func sizeForCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth / 3
        let height = width + 60
        return CGSize(width: width, height: height)
    }
    
    private func heightForCollection() -> CGFloat {
        let numberOfRows = CGFloat(cellControllers.count) / 3
        return sizeForCell().height * ceil(numberOfRows)
    }
}

extension AchievementsCollectionCellController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellControllers[indexPath.item].view(in: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (cellControllers[indexPath.item] as? SelectableCellController)?.didSelect()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForCell()
    }
}
