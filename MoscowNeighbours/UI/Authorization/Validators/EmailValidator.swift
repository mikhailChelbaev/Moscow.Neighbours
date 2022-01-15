//
//  EmailValidator.swift
//  MoscowNeighbours
//
//  Created by Mikhail on 16.01.2022.
//

import Foundation

struct EmailValidator {
    func isValid(email: String) -> String? {
        if email.contains("@") && email.count > 5 {
            return nil
        } else {
            return "auth.email_error_invalid".localized
        }
    }
}
