//
//  UserProvider.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 04.02.2022.
//

import Foundation

protocol UserProvider {
    func fetchUser() async throws -> UserModel
}
