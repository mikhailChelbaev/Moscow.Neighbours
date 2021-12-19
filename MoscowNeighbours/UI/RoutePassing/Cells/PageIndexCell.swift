//
//  PageIndexCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 24.09.2021.
//

import UIKit

final class PageIndexCell: CellView, PagerPresentable {
    
    enum Layout {
        static let height: CGFloat = 46
    }
    
    let indicator: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .grayBackground
        pc.currentPageIndicatorTintColor = .projectRed
        return pc
    }()
    
    var currentIndex: Int = 0
    
    var pagerDelegate: PagerDelegate?
    
    var numberOfPages: Int {
        set {
            indicator.numberOfPages = newValue
        }
        get {
            indicator.numberOfPages
        }
    }
    
    override func commonInit() {
        addSubview(indicator)
        indicator.stickToSuperviewEdges([.top, .bottom], insets: .init(top: 10, left: 0, bottom: 10, right: 0))
        indicator.centerHorizontally()
        
        indicator.addTarget(self, action: #selector(handlePageChange), for: .valueChanged)
    }
    
    func changePage(newIndex: Int, animated: Bool) {
        indicator.currentPage = newIndex
    }
    
    @objc private func handlePageChange() {
        pagerDelegate?.pageDidChange(indicator.currentPage, source: .pageIndicator)
    }
    
}
