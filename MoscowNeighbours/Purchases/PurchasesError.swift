//
//  PurchasesError.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.02.2022.
//

import Foundation

enum PurchasesError: Error {
    case purchaseInProgress
    case productNotFound
    case paymentsRestricted
    case userNotAuthorized
    case userNotVerified
    case unknown
}
