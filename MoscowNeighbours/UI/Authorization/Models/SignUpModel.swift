//
//  SignUpModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 31.12.2021.
//

import Foundation

// MARK: - SignUpModel

struct SignUpModel {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    var isValid: Bool {
        return username.count >= 3 && !password.isEmpty && !email.isEmpty
    }
}

// MARK: - SignUpDto

struct SignUpDto: Codable {
    let name: String
    let email: String
    let password: String
    
    init(from model: SignUpModel) {
        name = model.username
        email = model.email
        password = model.password
    }
}
