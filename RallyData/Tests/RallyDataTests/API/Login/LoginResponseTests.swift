//
//  LoginResponseTests.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import XCTest
import RallyCore
import RallyMock
@testable import RallyData

class LoginResponseTests: XCTestCase {
    func testLoginResponseDecoded() throws {
        let userResponse = RallyMock.LoginResponse.User.valid
        let loginResponse = Data(RallyMock.LoginResponse.with(userResponse).utf8)
        
        let expectedUser = try Data(userResponse.utf8).decoded() as User
        let expectedDecodedLoginResponse = LoginResponse(user: expectedUser)
        let decodedLoginResponse = try loginResponse.decoded() as RallyData.LoginResponse
        
        XCTAssertEqual(expectedDecodedLoginResponse, decodedLoginResponse)
    }
}
