//
//  CollectionSuccessDataSource.swift
//  What2Watch
//
//  Created by Mikhail on 06.04.2021.
//

import UIKit

@objc protocol CollectionSuccessDataSource: AnyObject {
    func successCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func successCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    @objc optional func successNumberOfSections(in collectionView: UICollectionView) -> Int
    @objc optional func successCollectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    @objc optional func successCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
