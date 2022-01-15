//
//  UserService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

protocol UserServiceOutput {
    @MainActor func userFetched(_ model: UserModel)
    @MainActor func userFetchFailed(_ error: NetworkError)
}

final class UserService: BaseNetworkService<UserServiceOutput> {
    
    // MARK: - StorageKeys
    
    enum StorageKeys: String {
        case currentUser
        case pushNotifications
        case emailNotifications
    }
    
    // MARK: - Internal Properties
    
    private(set) var currentUser: UserModel?
    var isAuthorized: Bool {
        return currentUser != nil
    }
    
    static let main: UserService = .init()
    
    var isPushNotificationsEnabled: Bool {
        set {
            cache.store(data: newValue, key: StorageKeys.pushNotifications.rawValue)
        }
        get {
            cache.get(key: StorageKeys.pushNotifications.rawValue) ?? false
        }
    }
    
    var isEmailNotificationsEnabled: Bool {
        set {
            cache.store(data: newValue, key: StorageKeys.emailNotifications.rawValue)
        }
        get {
            cache.get(key: StorageKeys.emailNotifications.rawValue) ?? false
        }
    }
    
    // MARK: - Private Properties
    
    private let cache: StoreContainer
    
    private let api: ApiRequestsFactory
    private let jwtService: JWTService
    
    // MARK: - Init
    
    private override init() {
        api = .main
        jwtService = .main
        cache = UserDefaults.standard

        currentUser = cache.get(key: StorageKeys.currentUser.rawValue)
    }
    
    // MARK: - Internal Methods
    
    func fetchUser() {
        Task {
            let result = await requestSender.send(request: api.userRequest,
                                                  type: UserModel.self)
            
            switch result {
            case .success(let model):
                for observer in observers {
                    await observer.value.userFetched(model)
                }
                storeCurrentUser(model)
                
            case .failure(let error):
                for observer in observers {
                    await observer.value.userFetchFailed(error)
                }
            }
        }
    }
    
    func logout() {
        storeCurrentUser(nil)
        jwtService.updateToken(nil)
    }
    
    // MARK: - Private Methods
    
    private func storeCurrentUser(_ model: UserModel?) {
        currentUser = model
        cache.store(data: model, key: StorageKeys.currentUser.rawValue)
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var userRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/me", method: .get)
    }
}
