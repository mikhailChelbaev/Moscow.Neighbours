//
//  SignInErrorsModel.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 15.01.2022.
//

import Foundation

struct SignInErrorsModel {
    var email: String?
    var password: String?
    
    var isEmpty: Bool {
        return email == nil && password == nil
    }
}
