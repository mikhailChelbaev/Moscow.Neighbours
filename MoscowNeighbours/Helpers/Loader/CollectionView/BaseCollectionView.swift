//
//  BaseCollectionView.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    weak var statusProvider: LoadingStatusProvider? {
        didSet {
            dataSourceImpl.statusProvider = statusProvider
        }
    }
    
    weak var successDataSource: CollectionSuccessDataSource? {
        didSet {
            dataSourceImpl.successDataSource = successDataSource
        }
    }
    
    private var dataSourceImpl: CustomCollectionViewDataSource = CustomCollectionViewDataSourceImpl()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = dataSourceImpl
        self.delegate = dataSourceImpl
        
        register(EmptyStateCell.self, kind: .cell)
        register(LoadingCell.self, kind: .cell)
    }
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, dataSource: CustomCollectionViewDataSource) {
        self.dataSourceImpl = dataSource
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.dataSource = dataSourceImpl
        self.delegate = dataSourceImpl
        
        register(EmptyStateCell.self, kind: .cell)
        register(LoadingCell.self, kind: .cell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
