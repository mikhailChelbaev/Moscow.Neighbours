//
//  CellView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.07.2021.
//

import UIKit

public class CellView: UIView {
    
    public static var reuseId: String {
        return String(describing: Self.self)
    }
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configureView() { }
    
}
