//
//  AuthServiceTests.swift
//  ManpowerTests
//
//  Created by Jaime Jazareno III on 4/11/22.
//

import XCTest
@testable import Manpower

class AuthServiceTests: XCTestCase {
    private var service: AuthServiceable?
    override func setUpWithError() throws {
        service = AuthMockService()
    }

    override func tearDownWithError() throws {
        service = nil
    }

    func testSuccessSignIn() throws {
        let user = try! service?.signIn(email: "tester1@tester.com", password: "Password1!")
        XCTAssertNotNil(user)
        XCTAssertEqual((service as! AuthMockService).sampleUsers.first, user)
    }

    func testNoUserFoundSignin() throws {
        let email = "notuser@tester.com"
        do {
            _ = try service?.signIn(email: email, password: "Password1!")
        } catch(let err) {
            XCTAssertEqual(AuthService.AuthError.noUserFound(email: email), err as! AuthService.AuthError)
        }
    }

    func testInvalidCredentialsSignin() throws {
        do {
            _ = try service?.signIn(email: "tester1@tester.com", password: "IncorrectPassword!")
        } catch(let err) {
            XCTAssertEqual(AuthService.AuthError.invalidCredentials, err as! AuthService.AuthError)
        }
    }

    func testSuccessSignUp() throws {
        let user = try! service?.signUp(name: "New User", email: "tester4@tester.com", password: "Password1!")
        XCTAssertNotNil(user)
        XCTAssertEqual((service as! AuthMockService).sampleUsers.last!, user)
    }

    func testExistingUserSignup() throws {
        let email = "tester1@tester.com"

        do {
            _ = try service?.signUp(name: "New user", email: email, password: "Password!!")
        } catch(let err) {
            XCTAssertEqual(AuthService.AuthError.existing(email: email), err as! AuthService.AuthError)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
