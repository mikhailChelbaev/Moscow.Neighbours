//
//  AchievementsService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 08.05.2022.
//

import Foundation

final class AchievementsService: BaseNetworkService {
    private let api: ApiRequestsFactory
    
    init(api: ApiRequestsFactory) {
        self.api = api
        
        super.init()
    }
}
    
extension AchievementsService: AchievementsProvider {
    typealias RetrieveResult = AchievementsProvider.Result
    
    func retrieveAchievements(completion: @escaping (RetrieveResult) -> Void) {
        Task {
            let result = await requestSender.send(request: api.achievementsRetrieveRequest, type: [RemoteAchievements].self)
            
            completion(result
                .map { response in
                    response.map { $0.toModel() }
                }
                .mapError { $0 as Error })
        }
    }
}

extension AchievementsService: AchievementsSaver {
    typealias StoreResult = AchievementsSaver.Result
    
    func storeAchievement(_ completedAchievement: CompletedAchievement, completion: @escaping (StoreResult) -> Void) {
        Task {
            let body = RemoteCompletedAchievement.from(completedAchievement)
            let result = await requestSender.send(request: api.achievementsStoreRequest(body), type: MessageResponse.self)
            
            completion(result
                .map { _ in () }
                .mapError { $0 as Error })
        }
    }
}
 
private extension ApiRequestsFactory {
    var achievementsRetrieveRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/achievements", method: .get)
    }
    
    func achievementsStoreRequest(_ body: RemoteCompletedAchievement) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/achievements", body: body, method: .post)
    }
}
