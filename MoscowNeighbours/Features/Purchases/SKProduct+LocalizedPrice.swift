//
//  SKProduct+LocalizedPrice.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import StoreKit

extension SKProduct: Product {
    public var id: String {
        return productIdentifier
    }
    
    public var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price) ?? ""
    }
}
