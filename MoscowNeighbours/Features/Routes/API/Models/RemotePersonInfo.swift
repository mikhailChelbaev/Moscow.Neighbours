//
//  RemotePersonInfo.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

struct RemotePersonInfo: Decodable {
    let id: String
    let person: RemotePerson
    let place: RemotePlace
    let coordinates: RemoteLocationCoordinates
}
