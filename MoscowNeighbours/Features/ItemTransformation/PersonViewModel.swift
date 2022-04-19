//
//  PersonViewModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 19.04.2022.
//

import Foundation

public struct PersonViewModel {
    public let name: String
    public let fullDescription: NSAttributedString
    public let shortDescription: NSAttributedString
    public let avatarUrl: String?
    public let info: [ShortInfo]
    public let placeName: String
    public let address: String
    public let coordinates: LocationCoordinates
}
