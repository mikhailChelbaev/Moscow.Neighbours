//
//  AccountConfirmationRequest.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.01.2022.
//

import Foundation

struct AccountConfirmationRequest: Encodable {
    let email: String
    let code: String
}
