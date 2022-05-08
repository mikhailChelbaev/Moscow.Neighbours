//
//  AchievementsProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import Foundation

public struct Achievement {
    public let name: String
    public let imageURL: String
    public let date: Date?
}

public protocol AchievementsProvider {
    typealias Result = Swift.Result<[Achievement], Error>
    
    func retrieveAchievements(completion: @escaping (Result) -> Void)
}
