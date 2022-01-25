//
//  SignUpErrorsModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.01.2022.
//

import Foundation

struct SignUpErrorsModel {
    var email: String?
    var username: String?
    var password: String?
    
    var isEmpty: Bool {
        email == nil && username == nil && password == nil
    }
}
