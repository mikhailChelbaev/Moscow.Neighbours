//
//  NetworkError.swift
//  HSEApplicant
//
//  Created by Mikhail on 18.12.2021.
//

import Foundation

struct NetworkError {
    enum NetworkErrorType {
        case url
        case network
        case http(statusCode: Int)
        case parsing
    }
    
    let message: String
    let type: NetworkErrorType
    let description: NetworkErrorDescription?
    
    init(message: String, type: NetworkErrorType, description: NetworkErrorDescription? = nil) {
        self.message = message
        self.type = type
        self.description = description
    }
}
