//
//  UserState.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 27.03.2022.
//

import Foundation

final class UserState {
    
    // MARK: - StorageKeys
    
    enum StorageKeys: String {
        case currentUser
        case pushNotifications
        case emailNotifications
    }
    
    private let cache: StoreContainer
    
    static let shared: UserState = .init()
    
    init(storeContainer: StoreContainer = UserDefaults.standard) {
        cache = storeContainer
    }
    
    var isAuthorized: Bool {
        return currentUser != nil
    }
    
    var isVerified: Bool {
        guard let currentUser = currentUser else {
            return false
        }
        return currentUser.isVerified
    }
    
    var currentUser: UserModel? {
        set {
            cache.store(data: newValue, key: StorageKeys.currentUser.rawValue)
            observers.forEach { $0.value.didChangeUserModel(state: self) }
        }
        get {
            cache.get(key: StorageKeys.currentUser.rawValue)
        }
    }
    
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
    
    // MARK: - Observation
    
    private var observers: [String: UserStateDelegate] = [:]
    
    func register(_ output: UserStateDelegate) {
        observers[String(describing: output.self)] = output
    }
    
    func remove(_ output: UserStateDelegate) {
        observers[String(describing: output.self)] = nil
    }
}

extension UserState: Logoutable {
    func logout() {
        currentUser = nil
    }
}
