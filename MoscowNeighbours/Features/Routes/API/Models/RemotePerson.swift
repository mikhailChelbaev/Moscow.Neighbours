//
//  RemotePerson.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

struct RemotePerson: Decodable {
    let name: String
    let description: String
    let shortDescription: String
    let avatarUrl: String?
    let info: [RemoteShortInfo]
}
