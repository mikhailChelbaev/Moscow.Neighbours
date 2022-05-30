//
//  UsernameValidator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.01.2022.
//

import Foundation

struct UsernameValidator {
    private init() {}
  
    static func isValid(username: String) -> String? {
        if username.count < 3 {
            return "auth.username_error.short".localized
        } else if username.count > 16 {
            return "auth.username_error_long".localized
        }
        return nil
    }
}
