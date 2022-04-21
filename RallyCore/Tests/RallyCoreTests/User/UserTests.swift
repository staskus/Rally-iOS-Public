//
//  UserTests.swift
//  RallyCoreTests
//
//  Created by Povilas Staskus on 9/23/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import XCTest
import RallyMock
@testable import RallyCore

class UserTests: XCTestCase {

    func testUserParsed_validUserData() throws {
        let validUserTestData = RallyMock.LoginResponse.User.valid

        let user = try Data(validUserTestData.utf8).decoded() as User

        let expectedUser = User(
            login: "email@gmail.com",
            sessionId: "weytrt56-shfd765-suyftsud567-sdiufys657"
        )

        XCTAssertEqual(user, expectedUser)
    }

    func testUserParsed_validUserData_additionalField() throws {
        let validUserTestData = RallyMock.LoginResponse.User.validAdditionalField

        let user = try Data(validUserTestData.utf8).decoded() as User

        let expectedUser = User(
            login: "email@gmail.com",
            sessionId: "weytrt56-shfd765-suyftsud567-sdiufys657"
        )

        XCTAssertEqual(user, expectedUser)
    }

    func testUserParsed_invalidLoginKey() {
        let invalidUserTestData = RallyMock.LoginResponse.User.invalid

        let user = try? Data(invalidUserTestData.utf8).decoded() as User

        XCTAssertEqual(user, nil)
    }
}
