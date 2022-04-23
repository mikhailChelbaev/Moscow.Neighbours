//
//  PurchaseOperationProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 23.04.2022.
//

import Foundation

public protocol PurchaseOperationProvider {
    typealias Result = Swift.Result<Bool, Error>
    
    func purchaseProduct(product: Product, completion: @escaping (Result) -> Void)
    func restorePurchases(completion: @escaping (Result) -> Void)
}
