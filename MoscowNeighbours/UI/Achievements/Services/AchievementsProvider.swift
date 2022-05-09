//
//  AchievementsProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import Foundation

public protocol AchievementsProvider {
    typealias Result = Swift.Result<[Achievement], Error>
    
    func retrieveAchievements(completion: @escaping (Result) -> Void)
}
