//
//  CustomCollectionViewDataSource.swift
//  What2Watch
//
//  Created by Mikhail on 04.04.2021.
//

import UIKit

protocol CustomCollectionViewDataSource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var statusProvider: LoadingStatusProvider? { set get }
    var successDataSource: CollectionSuccessDataSource? { set get }
}

class CustomCollectionViewDataSourceImpl: NSObject {
    weak var statusProvider: LoadingStatusProvider?
    weak var successDataSource: CollectionSuccessDataSource?
}

extension CustomCollectionViewDataSourceImpl: CustomCollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let statusProvider = statusProvider else { return 0 }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successNumberOfSections?(in: collectionView) ?? 0
        default:
            return 1
        }        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let statusProvider = statusProvider else { return 0 }
        guard let successDataSource = successDataSource else { fatalError("No success data source") }
        
        switch statusProvider.status {
        case .success:
            return successDataSource.successCollectionView(collectionView, numberOfItemsInSection: section)
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let statusProvider = statusProvider else { return UICollectionViewCell() }
        guard let successDataSource = successDataSource else { fatalError("No success data source") }
        
        switch statusProvider.status {
        case .error(let data), .noData(let data):
            let cell = collectionView.dequeue(EmptyStateCell.self, for: indexPath)
            cell.view.dataProvider = data
            return cell
        case .loading:
            let cell = collectionView.dequeue(LoadingCell.self, for: indexPath)
            cell.view.update()
            return cell
        case .success:
            return successDataSource.successCollectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let statusProvider = statusProvider else { return UICollectionReusableView() }
        
        switch statusProvider.status {
        case .success:
            return successDataSource?.successCollectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) ?? UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let statusProvider = statusProvider else { return }
        
        switch statusProvider.status {
        case .success:
            successDataSource?.successCollectionView?(collectionView, didSelectItemAt: indexPath)
        default:
            break
        }
    }
}
