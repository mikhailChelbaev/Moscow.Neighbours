//
//  NetworkErrorDescription.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.01.2022.
//

import Foundation

enum NetworkErrorDescription: String, Codable {
    case wrongPassword = "WRONG_PASSWORD"
    case userNotFound = "USER_NOT_FOUND"
    
    case unknown
    
    init(from decoder: Decoder) throws {
        self = try NetworkErrorDescription(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
