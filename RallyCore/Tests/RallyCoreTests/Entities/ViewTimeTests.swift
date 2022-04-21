//
//  ViewTimeTests.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import XCTest
@testable import RallyCore

final class ViewTimeTests: XCTestCase {
    func testViewTimeRequestParsed_validData() throws {
        let data = viewTimeRequest
        
        let viewTimeRequest = try Data(data.utf8).decoded() as ViewTimeRequest
        
        XCTAssertNotNil(viewTimeRequest)
    }
    
    func testViewTimeResponseParsed_validData_resultOk() throws {
        let data = viewTimeResponseOk
        
        let viewTimeResponse = try Data(data.utf8).decoded() as ViewTimeResponse
        
        XCTAssertTrue(viewTimeResponse.result.isAccepted)
    }
    
    func testViewTimeResponseParsed_validData_resultError() throws {
        let data = viewTimeResponseError
        
        let viewTimeResponse = try Data(data.utf8).decoded() as ViewTimeResponse
        
        XCTAssertFalse(viewTimeResponse.result.isAccepted)
    }
}

// swiftlint:disable line_length
extension ViewTimeTests {
    var viewTimeRequest: String {
        return """
        {"ViewTime":{"SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657","EventId":"9877","QNo": 2,"AFirstSeenTimestamp":"2020-04-12T16:23:04+00:00"}}
        """
    }
    
    var viewTimeResponseOk: String {
        return """
        {  "ViewTime": {  "SessionID": "weytrt56-shfd765-suyftsud567-sdiufys657",  "EventId": "9877",  "QNo": 2,  "Result": "Ok"  }  }
        """
    }
    
    var viewTimeResponseError: String {
        return """
        {  "ViewTime": {  "SessionID": "weytrt56-shfd765-suyftsud567-sdiufys657",  "EventId": "9877",  "QNo": 2,  "Result": "Error"  }  }
        """
    }
}
