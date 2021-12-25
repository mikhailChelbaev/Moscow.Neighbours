//
//  LoadingCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 28.10.2021.
//

import UIKit

final  class LoadingCell: CellView {
    
    private let indicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        return aiv
    }()
    
    override func setUpView() {
        addSubview(indicator)
        indicator.placeInCenter()
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = false
        
        height(190)
    }
    
    func update() {
        indicator.startAnimating()
    }
    
}

