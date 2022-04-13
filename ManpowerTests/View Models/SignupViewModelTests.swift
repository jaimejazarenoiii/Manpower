//
//  SignupViewModelTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower

class SignupViewModelTests: XCTestCase {
    private var viewModel: SignupViewModelTypes?

    override func setUpWithError() throws {
        let service = AuthMockService()
        viewModel = SignupViewModel(authServiceable: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignupSuccess() throws {
        viewModel!.inputs.set(companyName: "Hello Name")
        viewModel!.inputs.set(email: "test@gmail.com")
        viewModel!.inputs.set(password: "123123")
        viewModel!.inputs.set(passwordConfirmation: "123123")

        XCTAssertEqual(viewModel!.outputs.isNameValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isPasswordValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isPasswordConfirmationValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isSignupButtonEnabled.value!, true)

        viewModel!.inputs.signup()

        XCTAssertNotEqual(viewModel!.outputs.createdUser.value, nil)
    }

    func testNameError() throws {
        viewModel!.inputs.set(companyName: "He")

        XCTAssertEqual(viewModel!.outputs.isNameValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.nameNotValidErrMssg.value!, "Name should be at least 5 in characters.")


        XCTAssertEqual(viewModel!.outputs.createdUser.value, nil)
    }

    func testEmailError() throws {
        viewModel!.inputs.set(email: "He")

        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.emailNotValidErrMssg.value!, "Entered email is not valid.")


        XCTAssertEqual(viewModel!.outputs.createdUser.value, nil)
    }

    func testPasswordError() throws {
        viewModel!.inputs.set(password: "He")

        XCTAssertEqual(viewModel!.outputs.isPasswordValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.passwordNotValidErrMssg.value!, "Password has to be from 6 to 20 characters long.")


        XCTAssertEqual(viewModel!.outputs.createdUser.value, nil)
    }

    func testPasswordConfirmationError() throws {
        viewModel!.inputs.set(password: "123123")
        viewModel!.inputs.set(passwordConfirmation: "232323")

        XCTAssertEqual(viewModel!.outputs.isPasswordConfirmationValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.passwordConfirmationNotValidErrMssg.value!, "Doesn't match the password.")


        XCTAssertEqual(viewModel!.outputs.createdUser.value, nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
