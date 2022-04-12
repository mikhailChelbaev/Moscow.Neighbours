//
//  LoadingCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 28.10.2021.
//

import UIKit

public final class LoadingCell: CellView {
    
    private let indicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        return aiv
    }()
    
    public override func configureView() {
        addSubview(indicator)
        indicator.placeInCenter()
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = false
        
        height(190)
    }
    
    public func update() {
        indicator.startAnimating()
    }
    
}

