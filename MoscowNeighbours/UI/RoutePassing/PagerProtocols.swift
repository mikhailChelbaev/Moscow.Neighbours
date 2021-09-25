//
//  PagerProtocols.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.09.2021.
//

import UIKit

enum PagerSource {
    case scrollView
    case pageIndicator
}

protocol PagerPresentable: UIView {
    var currentIndex: Int { get }
    var pagerDelegate: PagerDelegate? { set get }
    
    func changePage(newIndex: Int, animated: Bool)
}

protocol PagerDelegate: AnyObject {
    func pageDidChange(_ index: Int, source: PagerSource)
}

protocol PagerMediator: PagerDelegate {
    var scrollView: PagerPresentable? { get }
    var pageIndicator: PagerPresentable? { get }    
}
