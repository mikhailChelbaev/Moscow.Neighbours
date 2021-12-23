//
//  Route.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 07.10.2021.
//

import Foundation

struct Route: Codable {
    let id: String
    let name: String
    let description: String
    let coverUrl: String?
    let duration: String
    let distance: String
    let personsInfo: [PersonInfo]
}
