//
//  RequestSenderWithTokenRefresh.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 05.01.2022.
//

import Foundation

final class RequestSenderWithTokenRefresh: RequestSender {
    
    // MARK: - Private Properties
    
    private let requestSender: RequestSender = BaseRequestSender()
    private let jwtService: JWTService = .main
    
    // MARK: - Internal Methods
    
    func send<ResultModel: Decodable>(request: ApiRequest,
                                      type: ResultModel.Type) async -> RequestResult<ResultModel> {
        let requestResult = await requestSender.send(request: request, type: type)
        
        if case .failure(let err) = requestResult,
           case .http(let status) = err.type,
           status == 401 {
            // token expired, it should be refreshed
            return await jwtService.refreshTokenIfNeeded(resultType: type) {
                await requestSender.send(request: request, type: type)
            }

        } else {
            return requestResult
        }
    }
    
}
