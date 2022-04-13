//
//  EmployeeFormViewModelTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower
class EmployeeFormViewModelTests: XCTestCase {
    var viewModel: EmployeeFormViewModelTypes?
    var service: EmployeeServiceable!
    override func setUpWithError() throws {
        service = EmployeeMockService()
        viewModel = EmployeeFormViewModel(employeeServiceable: service)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessEmployeeCreation() throws {
        viewModel!.inputs.set(name: "Hello Name")
        viewModel!.inputs.set(email: "test@gmail.com")

        XCTAssertEqual(viewModel!.outputs.isNameValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.valid)

        viewModel!.inputs.save()

        XCTAssert(viewModel!.outputs.isSuccess.value!)
    }

    func testNameError() throws {
        viewModel!.inputs.set(name: "He")

        XCTAssertEqual(viewModel!.outputs.isNameValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.nameNotValidErrMssg.value!, "Name should be at least 5 in characters.")

        viewModel?.inputs.save()

        XCTAssertEqual(viewModel!.outputs.isSuccess.value, nil)
    }

    func testEmailError() throws {
        viewModel!.inputs.set(email: "He")

        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.emailNotValidErrMssg.value!, "Entered email is not valid.")

        viewModel?.inputs.save()

        XCTAssertEqual(viewModel!.outputs.isSuccess.value, nil)
    }

    func testErrorEmployeeCreation() throws {
        viewModel!.inputs.set(name: "Ho")
        viewModel!.inputs.set(email: "test.com")

        XCTAssertEqual(viewModel!.outputs.isNameValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.invalid)

        viewModel!.inputs.save()

        XCTAssertEqual(viewModel!.outputs.isSuccess.value, nil)
        XCTAssertEqual(viewModel!.outputs.error.value!.localizedDescription, "Please fix form")
    }

    func testSetEmployee() throws {
        let employee = Employee(name: "zxc1", email: "tester@gmail.com")
        viewModel!.inputs.set(employee: employee)
        viewModel!.inputs.set(email: "test.com")

        XCTAssertEqual(viewModel!.outputs.employee.value!, employee)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
