//
//  ErrorResponse.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.01.2022.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String?
    let description: NetworkErrorDescription?
}
