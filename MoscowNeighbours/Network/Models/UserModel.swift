//
//  UserModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 03.01.2022.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let email: String
    let isVerified: Bool
    
    init(from response: SignUpResponse) {
        name = response.name
        email = response.email
        isVerified = response.isVerified
    }
    
    init(name: String, email: String, isVerified: Bool) {
        self.name = name
        self.email = email
        self.isVerified = isVerified
    }
}
