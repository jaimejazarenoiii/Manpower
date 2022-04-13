//
//  AuthMockService.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import Foundation

class AuthMockService: AuthServiceable {
    var sampleUsers = [
        User(id: 0, name: "Tester1", email: "tester1@tester.com", password: "Password1!"),
        User(id: 1, name: "Tester2", email: "tester2@tester.com", password: "Password1!"),
        User(id: 2, name: "Tester3", email: "tester3@tester.com", password: "Password1!")
    ]

    func getCurrentUser() -> User? {
        sampleUsers.first
    }

    func signIn(email: String, password: String) throws -> User? {
        let users: [User] = sampleUsers
        guard let user = users.first(where: { $0.email == email }) else { throw AuthService.AuthError.noUserFound(email: email) }
        guard user.password == password else { throw AuthService.AuthError.invalidCredentials }

        return user
    }

    func signUp(name: String, email: String, password: String) throws -> User? {
        let users: [User] = sampleUsers
        guard users.first(where: { $0.email == email }) == nil else { throw AuthService.AuthError.existing(email: email) }

        let maxId = users.map { $0.id }.max() ?? 0
        let newUser = User(id: maxId + 1, name: name, email: email, password: password)

        sampleUsers.append(newUser)

        return newUser
    }
}
