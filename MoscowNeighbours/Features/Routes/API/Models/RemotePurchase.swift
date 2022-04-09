//
//  RemotePurchase.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

struct RemotePurchase: Decodable {
    enum Status: String, Decodable {
        case free
        case buy
        case purchased
    }
    
    var status: Status
    let productId: String?
}
