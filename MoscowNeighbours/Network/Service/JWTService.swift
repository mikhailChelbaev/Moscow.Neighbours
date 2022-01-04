//
//  JWTService.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

final class JWTService {
    
    // MARK: - StorageKeys
    
    enum StorageKeys: String {
        case accessToken
        case refreshToken
    }
    
    // MARK: - Properties
    
    private(set) var accessToken: String? {
        didSet { storage.store(data: accessToken, key: StorageKeys.accessToken.rawValue) }
    }
    private(set) var refreshToken: String? {
        didSet { storage.store(data: refreshToken, key: StorageKeys.refreshToken.rawValue) }
    }
    
    private let storage: StoreContainer
    
    static let main: JWTService = .init()
    
    // MARK: - Init
    
    private init() {
        storage = UserDefaults.standard
        
        accessToken = storage.get(key: StorageKeys.accessToken.rawValue)
        refreshToken = storage.get(key: StorageKeys.refreshToken.rawValue) 
    }
    
    // MARK: - Methods
    
    func updateToken(_ jwt: JWTResponse) {
        accessToken = jwt.accessToken
        refreshToken = jwt.refreshToken
    }
    
}
