//
//  EmployeeServiceTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower

class EmployeeServiceTests: XCTestCase {
    var service: EmployeeServiceable?

    override func setUpWithError() throws {
        service = EmployeeMockService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        service = nil
    }

    func testGetList() throws {
        let tasks = service!.getList()

        XCTAssertEqual((service as! EmployeeMockService).sampleEmployees, tasks)
    }

    func testAddTask() throws {
        var newEmployee = Employee(name: "New employee",
                                   email: "fdfj@gmail.com",
                                   status: .active,
                                   userId: 0)
        let maxId = (service as! EmployeeMockService).sampleEmployees.map { $0.id }.max() ?? 0
        newEmployee.id = maxId + 1
        service!.add(employee: newEmployee)

        XCTAssert((service as! EmployeeMockService).sampleEmployees.contains(newEmployee))
    }

    func testEditTask() throws {
        var employee = (service as! EmployeeMockService).sampleEmployees.last!
        let newName = "New employee"
        employee.name = newName
        service!.edit(employee: employee)
        XCTAssertEqual((service as! EmployeeMockService).sampleEmployees.last!.name, newName)
    }

    func testDeleteTask() throws {
        let employee = (service as! EmployeeMockService).sampleEmployees.last!
        XCTAssertEqual((service as! EmployeeMockService).sampleEmployees.count, 5)
        let employees = service!.delete(employee: employee)

        XCTAssertEqual((service as! EmployeeMockService).sampleEmployees.count, 4)
        XCTAssertEqual((service as! EmployeeMockService).sampleEmployees, employees)
        XCTAssertFalse(employees.contains(employee))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
