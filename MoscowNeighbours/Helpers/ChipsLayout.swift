//
//  ChipsLayout.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 18.09.2021.
//

import UIKit

public class ChipsLayout: UICollectionViewFlowLayout {
    
    // MARK: - init

    public override init() {
        super.init()
        common()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - methods

    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 0
        minimumInteritemSpacing = 10
        sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let att = super.layoutAttributesForElements(in:rect) else { return [] }
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0

        for a in att {
            if a.representedElementCategory != .cell { continue }

            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}

