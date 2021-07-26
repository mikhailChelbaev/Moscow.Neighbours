//
//  UICollectionView+Reuse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

extension UICollectionView {
    
    enum ElementKind {
        case header, footer, cell
    }
    
    func register<T: CellView>(_ type: T.Type, kind: ElementKind = .cell) {
        switch kind {
        case .cell:
            return register(CollectionCellWrapper<T>.self, forCellWithReuseIdentifier: T.reuseId)
        case .header:
            return register(CollectionReuseViewWrapper<T>.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId)
        case .footer:
            return register(CollectionReuseViewWrapper<T>.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseId)
        }
    }
    
    func dequeue<T: CellView>(_ type: T.Type, for indexPath: IndexPath) -> CollectionCellWrapper<T> {
        dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as! CollectionCellWrapper<T>
    }
    
    func dequeue<T: CellView>(_ type: T.Type, for indexPath: IndexPath, kind: ElementKind) -> CollectionReuseViewWrapper<T> {
        switch kind {
        case .cell:
            fatalError("Only header and footer can be dequeued with parameter kind")
        case .header:
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId, for: indexPath) as! CollectionReuseViewWrapper<T>
        case .footer:
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseId, for: indexPath) as! CollectionReuseViewWrapper<T>
        }
    }
    
}
