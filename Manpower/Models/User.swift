//
//  User.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

struct User: Codable, Equatable {
    var id: Int
    var name: String
    var email: String
    var password: String
}
