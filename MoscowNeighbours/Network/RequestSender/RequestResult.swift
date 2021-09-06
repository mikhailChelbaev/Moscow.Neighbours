//
//  RequestResult.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.09.2021.
//

import Foundation

enum RequestResult<T> {
    case success(T)
    case failure(String)
}
