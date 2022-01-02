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
    
    var isValid: Bool {
        return username.count >= 3 && !password.isEmpty
    }
}
