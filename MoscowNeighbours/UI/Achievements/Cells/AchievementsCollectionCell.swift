//
//  AchievementsCollectionCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import UIKit

final class AchievementsCollectionCell: CellView {
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    
    override func configureView() {
        addSubview(collectionView)
        collectionView.pinToSuperviewEdges(.all)
        collectionViewHeightConstraint = collectionView.height(0)
    }
    
    func updateCollectionHeight(_ newValue: CGFloat) {
        collectionViewHeightConstraint?.constant = newValue
        layoutIfNeeded()
    }
    
}
