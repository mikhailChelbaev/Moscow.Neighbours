//
//  PurchaseProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation

// TODO: - Separate protocol to follow ISP

public typealias RequestProductsResult = Result<[Product], Error>
public typealias PurchaseProductResult = Result<Bool, Error>

public typealias RequestProductsCompletion = (RequestProductsResult) -> Void
public typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void


public protocol PurchaseProvider {
    func fetchProducts(productIds: Set<String>, completion: @escaping RequestProductsCompletion)
    func purchaseProduct(productId: String, completion: @escaping PurchaseProductCompletion)
    func restorePurchases(completion: @escaping PurchaseProductCompletion)
}
