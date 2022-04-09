//
//  PurchaseProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation


typealias RequestProductsResult = Result<[Product], Error>
typealias PurchaseProductResult = Result<Bool, Error>

typealias RequestProductsCompletion = (RequestProductsResult) -> Void
typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void


protocol PurchaseProvider {
    func fetchProducts(productIds: Set<String>, completion: @escaping RequestProductsCompletion)
    func purchaseProduct(productId: String, completion: @escaping PurchaseProductCompletion)
    func restorePurchases(completion: @escaping PurchaseProductCompletion)
}
