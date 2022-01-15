//
//  PasswordValidator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.01.2022.
//

import Foundation

struct PasswordValidator {
    func isValid(password: String) -> String? {
        if password.count < 8 {
            return "auth.password_error_short".localized
        } else if password.count > 12 {
            return "auth.password_error_long".localized
        } else {
            return nil
        }
    }
}
