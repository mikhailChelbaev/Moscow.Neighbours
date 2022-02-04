//
//  UserProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

protocol UserProvider {
    var observers: [String: UserServiceDelegate] { set get }
    
    var currentUser: UserModel? { get }
    var isAuthorized: Bool { get }
    
    var isPushNotificationsEnabled: Bool { set get }
    var isEmailNotificationsEnabled: Bool { set get }
    
    func fetchUser() async throws
    func storeCurrentUser(_ model: UserModel?)
    func logout()
}


extension UserProvider {
    mutating func register(_ output: UserServiceDelegate) {
        observers[String(describing: output.self)] = output
    }
    
    mutating func remove(_ output: UserServiceDelegate) {
        observers[String(describing: output.self)] = nil
    }
}
