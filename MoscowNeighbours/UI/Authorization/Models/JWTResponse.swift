//
//  JWTResponse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 02.01.2022.
//

import Foundation

struct JWTResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
