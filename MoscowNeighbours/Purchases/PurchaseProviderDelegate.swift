//
//  PurchaseProviderDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation

protocol PurchaseProviderDelegate {
    func productsFetch(didReceive response: RequestProductsResult)
    func productPurchase(didReceive response: PurchaseProductResult)
}
