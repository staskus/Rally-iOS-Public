//
//  UserRepositoryTests.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import XCTest
import RxBlocking
import RallyCore
import RallyMock
@testable import RallyData

class UserRepositoryTests: XCTestCase {
    var userRepository: RallyData.UserRepository!
    var apiClient: APIClientSpy!
    var localUserDataStore: LocalUserStoreDataSpy!
    var localEventDataStore: LocalEventStoreDataSpy!
    
    override func setUp() {
        super.setUp()
        
        apiClient = APIClientSpy()
        localUserDataStore = LocalUserStoreDataSpy()
        localEventDataStore = LocalEventStoreDataSpy()
        userRepository = RallyData.UserRepository(
            apiClient: apiClient,
            localStore: localUserDataStore,
            localEventStore: localEventDataStore,
            queue: QuestionAnswerQueueMock()
        )
    }
    
//    func testLogin() throws {
//        let validLoginResponse = try getLoginResponse()
//        let validLoginRequest = try getLoginRequest()
//        let login = validLoginRequest.login
//
//        apiClient.responseToReturn = .just(validLoginResponse)
//
//        let user = userRepository.login(name: login.login, password: login.password).toBlockingFirst()
//
//        let expectedPath = "login"
//        let expectedRequest = validLoginRequest
//        let expectedUser = validLoginResponse.user
//
//        XCTAssertEqual(user, expectedUser)
//        XCTAssertEqual(apiClient.postPathCalled, expectedPath)
//        XCTAssertEqual(apiClient.postRequestCalled as? RallyData.LoginRequest, expectedRequest)
//    }
//
//    func testUserSavedOnLogin() throws {
//        let validLoginRequest = try getLoginRequest()
//        let login = validLoginRequest.login
//        apiClient.responseToReturn = .just(try getLoginResponse())
//
//        let user = userRepository.login(name: login.login, password: login.password).toBlockingFirst()
//
//        XCTAssertEqual(localUserDataStore.savedUser, user)
//    }
}

extension UserRepositoryTests {
    private func getLoginResponse() throws -> RallyData.LoginResponse {
        return try Data(RallyMock.LoginResponse.with(RallyMock.LoginResponse.User.valid).utf8).decoded() as RallyData.LoginResponse
    }
    
    private func getLoginRequest() throws -> RallyData.LoginRequest {
        return try Data(RallyMock.LoginRequest.with(RallyMock.LoginRequest.Login.valid).utf8).decoded() as RallyData.LoginRequest
    }
}

