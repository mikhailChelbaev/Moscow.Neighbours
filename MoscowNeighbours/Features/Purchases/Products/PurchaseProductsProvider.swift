//
//  PurchaseProductsProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import Foundation

public protocol PurchaseProductsProvider {
    typealias Result = Swift.Result<[Product], Error>
    
    func fetchProducts(productIds: Set<String>, completion: @escaping (Result) -> Void)
}
