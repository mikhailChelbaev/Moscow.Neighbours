//
//  PurchaseProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation


typealias RequestProductsResult = Result<[Product], Error>
typealias PurchaseProductResult = Result<Bool, Error>


protocol PurchaseProvider {
    var observers: [String: PurchaseProviderDelegate] { set get }
    
    func fetchProducts(productIds: Set<String>)
    func purchaseProduct(productId: String)
    func restorePurchases()
}

extension PurchaseProvider {
    mutating func register(_ output: PurchaseProviderDelegate) {
        observers[String(describing: output.self)] = output
    }
    
    mutating func remove(_ output: PurchaseProviderDelegate) {
        observers[String(describing: output.self)] = nil
    }
}
