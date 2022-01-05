//
//  JWTService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation
import JWTDecode

protocol JWTServiceOutput {
    @MainActor func refreshTokenFailed(with error: NetworkError)
}

final class JWTService: ObservableService {
    
    // MARK: - StorageKeys
    
    enum StorageKeys: String {
        case accessToken
        case refreshToken
    }
    
    // MARK: - Properties
    
    private let expireTimeTolerance = 60.0  // Seconds
    
    private(set) var accessToken: String? {
        didSet { storage.store(data: accessToken, key: StorageKeys.accessToken.rawValue) }
    }
    private(set) var refreshToken: String? {
        didSet { storage.store(data: refreshToken, key: StorageKeys.refreshToken.rawValue) }
    }
    
    var isAccessTokenExpired: Bool {
        isTokenExpired(token: accessToken)
    }
    var isRefreshTokenExpired: Bool {
        isTokenExpired(token: refreshToken)
    }
    
    private let storage: StoreContainer
    
    static let main: JWTService = .init()
    
    private let api: ApiRequestsFactory
    var requestSender: RequestSender = BaseRequestSender()
    
    var observers: [String: JWTServiceOutput] = [:]
    
    // MARK: - Init
    
    private init() {
        storage = UserDefaults.standard
        api = .main
        
        accessToken = storage.get(key: StorageKeys.accessToken.rawValue)
        refreshToken = storage.get(key: StorageKeys.refreshToken.rawValue) 
    }
    
    // MARK: - Internal Methods
    
    func updateToken(_ jwt: JWTResponse?) {
        accessToken = jwt?.accessToken
        refreshToken = jwt?.refreshToken
    }
    
    func refreshTokenIfNeeded<ResultModel: Decodable>(resultType: ResultModel.Type,
                                                      request: () async -> RequestResult<ResultModel>) async -> RequestResult<ResultModel> {
        guard isAccessTokenExpired else {
            return await request()
        }
        
        let result = await requestSender.send(request: api.refreshTokenRequest(refreshToken ?? ""),
                                              type: JWTResponse.self)
        
        switch result {
        case .success(let jwt):
            updateToken(jwt)
            return await request()
            
        case .failure(let error):
            if isRefreshTokenExpired {
                updateToken(nil)
                for observer in observers {
                    await observer.value.refreshTokenFailed(with: error)
                }
            }
            return .failure(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func isTokenExpired(token: String?) -> Bool {
        guard let token = token,
              let jwt = try? decode(jwt: token),
              let expiresAt = jwt.expiresAt else { return true }
        return expiresAt < Date().addingTimeInterval(expireTimeTolerance)
    }
    
}

extension ApiRequestsFactory {
    func refreshTokenRequest(_ refreshToken: String) -> ApiRequest {
        return makeRequest(url: host + "/api/v1/auth/refreshToken", body: refreshToken, method: .get)
    }
}
