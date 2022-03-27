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
}

extension SignUpModel {
    func toRequest() -> SignUpRequest {
        return SignUpRequest(name: username, email: email, password: password)
    }
}
