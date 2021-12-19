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
    
    let description: String
    let type: NetworkErrorType
}
