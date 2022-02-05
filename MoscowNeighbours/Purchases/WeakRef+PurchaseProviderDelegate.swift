//
//  WeakRef+PurchaseProviderDelegate.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation

extension WeakRef: PurchaseProviderDelegate where T: PurchaseProviderDelegate {
    func productsFetch(didReceive response: RequestProductsResult) {
        object?.productsFetch(didReceive: response)
    }
    
    func productPurchase(didReceive response: PurchaseProductResult) {
        object?.productPurchase(didReceive: response)
    }
}
