//
//  EmployeeServiceable.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

protocol EmployeeServiceable {
    func getList() -> [Employee]
    func add(employee: Employee)
    func delete(employee: Employee) -> [Employee]
    func edit(employee: Employee)
}
