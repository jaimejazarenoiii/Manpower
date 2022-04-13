//
//  EmailValidateable.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

protocol EmailValidateable {
    func isValidEmail(_ email: String) -> TextFieldStatus
}

extension EmailValidateable {
    func isValidEmail(_ email: String) -> TextFieldStatus {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? .valid : .invalid
    }
}
