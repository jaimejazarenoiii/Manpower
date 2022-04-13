//
//  DashboardViewModelTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower

class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModelTypes!
    var service: EmployeeServiceable!

    override func setUpWithError() throws {
        service = EmployeeMockService()
        viewModel = DashboardViewModel(employeeServiceable: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetList() throws {
        viewModel.inputs.viewDidLoad()

        XCTAssert(viewModel.outputs.employees.value.count > 0)
    }

    func testDeleteEmployee() throws {
        let employee = (service as! EmployeeMockService).sampleEmployees.last!
        _ = viewModel.inputs.delete(employee: employee)

        viewModel.inputs.refresh()

        XCTAssertFalse(viewModel.outputs.employees.value.contains(employee))
    }

    func testToggleStatus() throws {
        let employee = (service as! EmployeeMockService).sampleEmployees.last!
        viewModel.inputs.toggle(from: employee, isOn: true)

        viewModel.inputs.refresh()

        XCTAssertEqual(viewModel.outputs.employees.value.first(where: { $0.id == employee.id })!.status,
                  .active)

        viewModel.inputs.toggle(from: employee, isOn: false)

        viewModel.inputs.refresh()

        XCTAssertEqual(viewModel.outputs.employees.value.first(where: { $0.id == employee.id })!.status,
                       .inactive)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
