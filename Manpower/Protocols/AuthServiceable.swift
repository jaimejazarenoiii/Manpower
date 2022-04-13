//
//  AuthServiceable.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

protocol AuthServiceable {
    func signIn(email: String, password: String) throws -> User?
    func signUp(name: String, email: String, password: String) throws -> User?
    func getCurrentUser() -> User?
}
