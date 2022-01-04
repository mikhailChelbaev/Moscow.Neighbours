//
//  HandlerView.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 17.09.2021.
//

import UIKit

final class HandlerView: CellView {
    
    enum Layout {
        static var pullViewBorderInsets: CGFloat = 8
        static var pullViewHeight: CGFloat = 4
        static var pullViewWidth: CGFloat = 34
    }
    
    var handlerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
    }()
    
    override func configureView() {
        addSubview(handlerView)
        handlerView.pinToSuperviewEdges([.top, .bottom], insets: .init(top: Layout.pullViewBorderInsets, left: 0, bottom: Layout.pullViewBorderInsets, right: 0))
        handlerView.centerHorizontally()
        handlerView.exactSize(.init(width: Layout.pullViewWidth, height: Layout.pullViewHeight))
    }
    
    
}

