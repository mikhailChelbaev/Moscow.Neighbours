//
//  RoutePointsCollectionCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.09.2021.
//

import UIKit

final class RoutePointsCollectionCell: CellView, PagerPresentable {
    
    var currentIndex: Int = 0
    
    var pagerDelegate: PagerDelegate?
    
    var closePerson: PersonInfo?
    
    var mapPresenter: MapPresentable?
    
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
    
    private var route: Route?
    
    override func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(RoutePointCell.self)
        
        addSubview(collectionView)
        collectionView.stickToSuperviewEdges(.all)
        collectionView.height(Layout.height)
    }
    
    func update(
        with route: Route?,
        closePerson: PersonInfo?
    ) {
        self.route = route
        self.closePerson = closePerson
        collectionView.reloadData()
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
        cell.configureView = { [weak self] view in
            guard let personInfo = self?.route?.personsInfo[indexPath.item] else { return }
            let state: RoutePointCell.State = personInfo == self?.closePerson ? .onTheSpot : .going
            view.update(personInfo: personInfo, state: state, action: { [weak self] _ in
                self?.mapPresenter?.showPerson(personInfo, state: .middle)
            })
        }
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
