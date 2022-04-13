//
//  Employee.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

struct Employee: Codable, Equatable {
    enum Status: Codable {
        case active, inactive
    }

    var id: Int = -1
    var name: String
    var email: String
    var status: Status = .active
    var userId: Int = -1

    var exist: Bool {
        id > -1
    }

    init(id: Int = -1,
         name: String = "",
         email: String = "",
         status: Status = .active,
         userId: Int = -1) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
        self.userId = userId
    }
}
