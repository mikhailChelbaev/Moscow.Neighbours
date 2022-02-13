//
//  UserService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

final class UserService: BaseNetworkService, UserProvider {
    
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
    
    static let shared: UserService = .init()
    
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
    
    var observers: [String : UserServiceDelegate]
    
    // MARK: - Private Properties
    
    private let cache: StoreContainer
    
    private let api: ApiRequestsFactory
    private let jwtService: JWTService
    
    // MARK: - Init
    
    override init() {
        api = .main
        jwtService = .main
        cache = UserDefaults.standard
        observers = [:]

        currentUser = cache.get(key: StorageKeys.currentUser.rawValue)
    }
    
    // MARK: - Internal Methods
    
    func fetchUser() async throws {
        let result = await requestSender.send(request: api.userRequest,
                                              type: UserModel.self)
        
        switch result {
        case .success(let model):
            storeCurrentUser(model)
            
        case .failure(let error):
            throw error
        }
    }
    
    func logout() {
        storeCurrentUser(nil)
        jwtService.updateToken(nil)
    }
    
    func storeCurrentUser(_ model: UserModel?) {
        currentUser = model
        cache.store(data: model, key: StorageKeys.currentUser.rawValue)
        DispatchQueue.main.async { [self] in
            observers.forEach({ $0.value.didChangeUserModel(service: self) })
        }
    }
    
}

// MARK: - API

private extension ApiRequestsFactory {
    var userRequest: ApiRequest {
        return makeRequest(url: host + "/api/v1/me", method: .get)
    }
}
