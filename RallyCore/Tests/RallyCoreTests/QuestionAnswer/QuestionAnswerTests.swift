//
//  QuestionAnswerTests.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation

import XCTest
import RallyMock
@testable import RallyCore

final class QuestionAnswerTests: XCTestCase {
    
    func testQuestionAnswerParsed_validData() throws {
        let data = RallyMock.QuestionAnswerRequest.QuestionAnswer.valid
        
        let questionAnswer = try Data(data.utf8).decoded() as QuestionAnswer
        
        XCTAssertNotNil(questionAnswer)
    }
    
    func testQuestionAnswerResultParsed_validData() throws {
        let data = RallyMock.QuestionAnswerResponse.QuestionAnswerResult.valid
        
        let questionAnswerResult = try Data(data.utf8).decoded() as QuestionAnswerResult
        
        XCTAssertNotNil(questionAnswerResult)
    }
}
