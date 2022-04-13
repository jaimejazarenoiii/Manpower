//
//  SigninViewModelTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower

class SigninViewModelTests: XCTestCase {
    private var viewModel: SigninViewModelTypes?

    override func setUpWithError() throws {
        let service = AuthMockService()
        viewModel = SigninViewModel(authServiceable: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSigninSuccess() throws {
        viewModel!.inputs.set(email: "tester1@tester.com")
        viewModel!.inputs.set(password: "Password1!")

        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isPasswordValid.value!, TextFieldStatus.valid)

        viewModel!.inputs.signin()

        XCTAssertNotEqual(viewModel!.outputs.signedinUser.value, nil)
    }

    func testEmailError() throws {
        viewModel!.inputs.set(email: "He")

        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.emailNotValidErrMssg.value!, "Entered email is not valid.")


        XCTAssertEqual(viewModel!.outputs.signedinUser.value, nil)
    }

    func testPasswordError() throws {
        viewModel!.inputs.set(password: "He")

        XCTAssertEqual(viewModel!.outputs.isPasswordValid.value!, TextFieldStatus.invalid)
        XCTAssertEqual(viewModel!.outputs.passwordNotValidErrMssg.value!, "Password has to be from 6 to 20 characters long.")


        XCTAssertEqual(viewModel!.outputs.signedinUser.value, nil)
    }

    func testSigninError() throws {
        viewModel!.inputs.set(email: "tester1@tester.com")
        viewModel!.inputs.set(password: "Password!")

        XCTAssertEqual(viewModel!.outputs.isEmailValid.value!, TextFieldStatus.valid)
        XCTAssertEqual(viewModel!.outputs.isPasswordValid.value!, TextFieldStatus.valid)

        viewModel!.inputs.signin()

        XCTAssertEqual(viewModel!.outputs.signedinUser.value, nil)
        XCTAssertEqual(viewModel!.outputs.error.value! as? AuthService.AuthError, .invalidCredentials)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
