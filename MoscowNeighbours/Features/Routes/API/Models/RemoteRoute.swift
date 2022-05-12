//
//  RemoteRoute.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 09.04.2022.
//

import Foundation

struct RemoteRoute: Decodable {
    let id: String
    let name: String
    let description: String
    let coverUrl: String?
    let duration: String
    let distance: String
    let personsInfo: [RemotePersonInfo]
    let purchase: RemotePurchase
    let achievement: RemoteRouteAchievement?
}
