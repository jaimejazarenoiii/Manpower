//
//  AuthService.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

struct AuthService: AuthServiceable, Saveable {
    enum AuthError: Swift.Error, Equatable {
        case noUserFound(email: String)
        case existing(email: String)
        case invalidCredentials

        var message: String {
            switch (self) {
            case .existing(let email):
                return "Email address: \(email) already exist."
            case .noUserFound(let email):
                return "User with email address of \(email) is not found."
            case .invalidCredentials:
                return "Invalid credentials."
            }
        }
    }

    func signIn(email: String, password: String) throws -> User? {
        let users: [User] = try! FileLoader().loadFile(type: User.self, fromFileNamed: "users")
        guard let user = users.first(where: { $0.email == email }) else { throw AuthError.noUserFound(email: email) }
        guard user.password == password else { throw AuthError.invalidCredentials }

        return user
    }

    func signUp(name: String, email: String, password: String) throws -> User? {
        var users: [User] = try! FileLoader().loadFile(type: User.self, fromFileNamed: "users")
        guard users.first(where: { $0.email == email }) == nil else { throw AuthError.existing(email: email) }

        let maxId = users.map { $0.id }.max() ?? 0
        let newUser = User(id: maxId + 1, name: name, email: email, password: password)

        users.append(newUser)

        saveToJson(type: User.self, objects: users, fileName: "users")

        return newUser
    }

    func getCurrentUser() -> User? {
        let users: [User] = try! FileLoader().loadFile(type: User.self, fromFileNamed: "users")
        guard let currentUser = users
                .first(where: { $0.id == UserDefaults.standard.integer(forKey: "userId") }) else { return nil }
        return currentUser
    }
}
