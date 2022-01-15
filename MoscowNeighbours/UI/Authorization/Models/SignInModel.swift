//
//  SignInModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 31.12.2021.
//

import Foundation

// MARK: - SignInModel

struct SignInModel {
    var username: String = ""
    var password: String = ""
}

// MARK: - SignUpDto

struct SignInDto: Codable {
    let email: String
    let password: String
    
    init(from model: SignInModel) {
        email = model.username
        password = model.password
    }
}
