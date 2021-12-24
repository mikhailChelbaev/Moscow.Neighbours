//
//  RoutePointsCollectionCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.09.2021.
//

import UIKit

final class RoutePointsCollectionCell: CellView, PagerPresentable {
    
    enum Layout {
        static let height: CGFloat = 240
        static var cellSize: CGSize = .init(width: UIScreen.main.bounds.width, height: height)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Layout.cellSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = .zero
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .background
        return cv
    }()
    
    var currentIndex: Int = 0
    
    var pagerDelegate: PagerDelegate?
    
    var route: Route? {
        didSet { collectionView.reloadData() }
    }
    
    override func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(RoutePointCell.self)
        
        addSubview(collectionView)
        collectionView.stickToSuperviewEdges(.all)
        collectionView.height(Layout.height)
    }
    
    func changePage(newIndex: Int, animated: Bool) {
        collectionView.setContentOffset(CGPoint(x: CGFloat(newIndex) * frame.width, y: collectionView.contentOffset.y), animated: animated)
    }
    
}

extension RoutePointsCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return route?.personsInfo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RoutePointCell.self, for: indexPath)
        var state: RoutePointCell.State = .notVisited
        
        guard let personInfo = route?.personsInfo[indexPath.item] else {
            fatalError("There is no person info for index path: \(indexPath)")
        }
        
//        if mapPresenter?.viewedPersons.contains(personInfo) == true {
//            state = .review
//        } else if mapPresenter?.visitedPersons.contains(personInfo) == true {
//            state = .firstTime
//        }
//        cell.view.update(personInfo: personInfo, state: state, action: { [weak self] _ in
//            self?.mapPresenter?.showPerson(personInfo, state: .middle)
//        })
        
        return cell
    }
    
}

extension RoutePointsCollectionCell: UICollectionViewDelegateFlowLayout {
    
    private func getIndex(for offset: CGFloat) -> Int {
        Int((offset + frame.width / 2) / frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newIndex: Int = getIndex(for: scrollView.contentOffset.x)
        if newIndex != currentIndex {
            pagerDelegate?.pageDidChange(newIndex, source: .scrollView)
            currentIndex = newIndex
        }
    }
    
}
