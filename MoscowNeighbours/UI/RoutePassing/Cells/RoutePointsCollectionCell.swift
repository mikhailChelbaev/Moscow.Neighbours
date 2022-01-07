//
//  RoutePointsCollectionCell.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.09.2021.
//

import UIKit

final class RoutePointsCollectionCell: CellView {
    
    enum Layout {
        static let collectionHeight: CGFloat = 240
        static let indicatorHeight: CGFloat = 46
        static var cellSize: CGSize = .init(width: UIScreen.main.bounds.width, height: collectionHeight)
        static var totalHeight: CGFloat {
            return collectionHeight + indicatorHeight
        }
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
    
    let indicator: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .grayBackground
        pc.currentPageIndicatorTintColor = .projectRed
        return pc
    }()
    
    private var route: RouteViewModel?
    var buttonTapCallback: ((PersonViewModel) -> Void)?
    var indexDidChange: ((Int) -> Void)?
    var personState: ((PersonViewModel) -> PersonState)?
    
    override func configureView() {
        // collection set up
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(RoutePointCell.self)
        
        // indicator set up
        indicator.addTarget(self, action: #selector(handlePageChange), for: .valueChanged)
        
        // layout
        addSubview(indicator)
        indicator.top(10)
        indicator.centerHorizontally()
        
        addSubview(collectionView)
        collectionView.top(10, to: indicator)
        collectionView.pinToSuperviewEdges([.left, .right, .bottom])
        collectionView.height(Layout.collectionHeight)
    }
    
    func changeCollectionPage(newIndex: Int, animated: Bool) {
        collectionView.setContentOffset(CGPoint(x: CGFloat(newIndex) * frame.width, y: collectionView.contentOffset.y), animated: animated)
    }
    
    @objc private func handlePageChange() {
        let newIndex = indicator.currentPage
        changeCollectionPage(newIndex: newIndex, animated: true)
        indexDidChange?(newIndex)
    }
    
    func update(route: RouteViewModel,
                currentIndex: Int) {
        self.route = route
        
        indicator.numberOfPages = route.persons.count
        
        collectionView.reloadData()
        
        changeCollectionPage(newIndex: currentIndex, animated: true)
        indicator.currentPage = currentIndex
    }
    
}

extension RoutePointsCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return route?.persons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RoutePointCell.self, for: indexPath)
        
        guard let person = route?.persons[indexPath.item],
              let state = personState?(person) else {
            fatalError("There is no person or state info for index path: \(indexPath)")
        }
        
        cell.view.update(person: person,
                         state: state,
                         action: { [weak self] in
            self?.buttonTapCallback?(person)
        })
        
        return cell
    }
    
}

extension RoutePointsCollectionCell: UICollectionViewDelegateFlowLayout {
    
    private func getIndex(for offset: CGFloat) -> Int {
        Int((offset + frame.width / 2) / frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newIndex: Int = getIndex(for: scrollView.contentOffset.x)
        indicator.currentPage = newIndex
        indexDidChange?(newIndex)
    }
    
}
