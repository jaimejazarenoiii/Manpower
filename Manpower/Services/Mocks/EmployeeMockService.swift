//
//  EmployeeMockService.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import Foundation
class EmployeeMockService: EmployeeServiceable {
    var sampleEmployees = [
        Employee(id: 0, name: "Task 1", email: "asd1@gmail.com", status: .active, userId: 0),
        Employee(id: 1, name: "Task 2", email: "asd2@gmail.com", status: .active, userId: 0),
        Employee(id: 2, name: "Task 3", email: "asd3@gmail.com", status: .active, userId: 0),
        Employee(id: 3, name: "Task 4", email: "asd4@gmail.com", status: .active, userId: 0),
        Employee(id: 4, name: "Task 5", email: "asd5@gmail.com", status: .active, userId: 0),
    ]

    func getList() -> [Employee] {
        sampleEmployees
    }

    func add(employee: Employee) {
        sampleEmployees.append(employee)
    }

    func delete(employee: Employee) -> [Employee] {
        sampleEmployees.removeAll(where: { $0.id == employee.id })

        return sampleEmployees
    }

    func edit(employee: Employee) {
        guard let editedEmployeeIndex = sampleEmployees.enumerated()
            .first(where: { $0.element.id == employee.id })?.offset else { return }
        sampleEmployees[editedEmployeeIndex] = employee
    }
}
