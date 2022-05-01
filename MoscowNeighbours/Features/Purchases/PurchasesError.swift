//
//  PurchasesError.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 26.04.2022.
//

import Foundation

public enum PurchasesError: Error {
    case purchaseInProgress
    case paymentsRestricted
    case userNotAuthorized
    case userNotVerified
    case unknown
}
