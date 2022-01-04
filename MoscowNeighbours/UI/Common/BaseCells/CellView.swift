//
//  CellView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

class CellView: UIView {
    
    static var reuseId: String {
        return String(describing: Self.self)
    }
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureView() { }
    
}
