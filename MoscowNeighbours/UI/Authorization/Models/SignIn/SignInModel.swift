//
//  SignInModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 31.12.2021.
//

import Foundation

struct SignInModel {
    var username: String = ""
    var password: String = ""
}

extension SignInModel {
    func toRequest() -> SignInRequest {
        return SignInRequest(email: username, password: password)
    }
}
