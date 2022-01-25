//
//  SignUpResponse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 25.01.2022.
//

import Foundation

struct SignUpResponse: Decodable {
    let name: String
    let email: String
    let isVerified: Bool
}
