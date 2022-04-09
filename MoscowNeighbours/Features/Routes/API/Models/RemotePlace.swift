//
//  RemotePlace.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

struct RemotePlace: Decodable {
    let id: String
    let name: String
    let description: String?
    let address: String
}
