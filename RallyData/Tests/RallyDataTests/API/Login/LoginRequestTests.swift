//
//  LoginRequestTests.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import XCTest
import RallyMock
@testable import RallyData

class LoginRequestTests: XCTestCase {
    func testLoginRequestEncoded() throws {
        let login = try Data(RallyMock.LoginRequest.Login.valid.utf8).decoded() as Login
        let loginRequest = LoginRequest(login: login)
        
        let encodedLoginRequest = try? loginRequest.encoded()
        let expectedLoginRequest = Data(RallyMock.LoginRequest.with(RallyMock.LoginRequest.Login.valid).utf8)
        
        XCTAssertEqual(encodedLoginRequest, expectedLoginRequest)
    }
    
    func testLoginEncoded() throws {
        let login = Login(login: "email@gmail.com", password: "qwe123")

        let loginData = try login.encoded()
        let expectedLoginData = RallyMock.LoginRequest.Login.valid

        XCTAssertEqual(loginData, Data(expectedLoginData.utf8))
    }
}
