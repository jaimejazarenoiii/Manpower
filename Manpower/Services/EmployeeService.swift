//
//  EmployeeService.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

struct EmployeeService: EmployeeServiceable, Saveable {
    private var currentUser: User?

    init(currentUser: User?) {
        self.currentUser = currentUser
    }

    mutating func set(currentUser: User) {
        self.currentUser = currentUser
    }

    func getList() -> [Employee] {
        let employees = (try? FileLoader().loadFile(type: Employee.self, fromFileNamed: "employees")) ?? []
        return employees.filter { $0.userId == currentUser!.id }
    }

    func add(employee: Employee) {
        var newEmployee = employee
        var employees: [Employee] = try! FileLoader().loadFile(type: Employee.self, fromFileNamed: "employees")

        let maxId = employees.map { $0.id }.max() ?? 0
        newEmployee.id = maxId + 1
        newEmployee.userId = currentUser!.id

        employees.append(newEmployee)

        saveToJson(type: Employee.self, objects: employees, fileName: "employees")
    }

    func delete(employee: Employee) -> [Employee] {
        var employees = try! FileLoader().loadFile(type: Employee.self, fromFileNamed: "employees")
        employees.removeAll(where: { $0.id == employee.id })

        saveToJson(type: Employee.self, objects: employees, fileName: "employees")

        return employees.filter { $0.userId == currentUser!.id }
    }

    func edit(employee: Employee) {
        var employees = try! FileLoader().loadFile(type: Employee.self, fromFileNamed: "employees")
        guard let oldTask = employees.enumerated().first(where: { $0.element.id == employee.id }) else { return }
        employees[oldTask.offset] = employee

        saveToJson(type: Employee.self, objects: employees, fileName: "employees")
    }
}
