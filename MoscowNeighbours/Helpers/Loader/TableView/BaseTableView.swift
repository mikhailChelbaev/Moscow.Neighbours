//
//  BaseTableView.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import UIKit

open class BaseTableView: UITableView {
    
    public weak var statusProvider: LoadingStatusProvider? {
        didSet {
            dataSourceImpl.statusProvider = statusProvider
        }
    }
    
    public weak var successDataSource: TableSuccessDataSource? {
        didSet {
            dataSourceImpl.successDataSource = successDataSource
        }
    }
    
    public weak var loadingDelegate: LoadingDelegate? {
        didSet {
            dataSourceImpl.loadingDelegate = loadingDelegate
        }
    }
    
    public weak var errorDelegate: ErrorDelegate? {
        didSet {
            dataSourceImpl.errorDelegate = errorDelegate
        }
    }
    
    private var dataSourceImpl: CustomTableViewDataSource = CustomTableViewDataSourceImpl()
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = .leastNonzeroMagnitude
        }
        
        dataSource = dataSourceImpl
        delegate = dataSourceImpl
        
        register(EmptyStateCell.self)
        register(LoadingCell.self)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
