//
//  BaseTableView.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import UIKit

class BaseTableView: UITableView {
    
    weak var statusProvider: LoadingStatusProvider? {
        didSet {
            dataSourceImpl.statusProvider = statusProvider
        }
    }
    
    weak var successDataSource: TableSuccessDataSource? {
        didSet {
            dataSourceImpl.successDataSource = successDataSource
        }
    }
    
    private var dataSourceImpl: CustomTableViewDataSource = CustomTableViewDataSourceImpl()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        dataSource = dataSourceImpl
        delegate = dataSourceImpl
        
        register(EmptyStateCell.self)
        register(LoadingCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
