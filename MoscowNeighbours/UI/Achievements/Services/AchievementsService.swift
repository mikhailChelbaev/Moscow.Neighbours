//
//  AchievementsService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import Foundation

final class AchievementsService: BaseNetworkService, AchievementsProvider {
    private let api: ApiRequestsFactory
    
    typealias Result = AchievementsProvider.Result
    
    init(api: ApiRequestsFactory) {
        self.api = api
        
        super.init()
    }
    
    func retrieveAchievements(completion: @escaping (Result) -> Void) {
        Task {
            let result = await requestSender.send(request: api.achievementsRequest, type: [RemoteAchievements].self)
            
            completion(result
                .map { response in
                    response.map { AchievementsService.map($0) }
                }
                .mapError { $0 as Error })
        }
    }
    
    private static func map(_ response: RemoteAchievements) -> AchievementsSection {
        AchievementsSection(
            title: response.title,
            achievements: response.achievements.map { $0.toModel() })
    }
}

private extension RemoteAchievements.Achievement {
    func toModel() -> Achievement {
        Achievement(
            name: name,
            imageURL: imageUrl,
            date: date)
    }
}
 
private extension ApiRequestsFactory {
    var achievementsRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/achievements", method: .get)
    }
}
