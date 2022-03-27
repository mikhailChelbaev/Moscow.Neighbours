//
//  SignUpRequest.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.03.2022.
//

import Foundation

struct SignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
}
