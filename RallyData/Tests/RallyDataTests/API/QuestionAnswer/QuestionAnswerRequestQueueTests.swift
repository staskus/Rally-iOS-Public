//
//  QuestionAnswerAnswerQueueTests.swift
//  
//
//  Created by Povilas Staskus on 11/14/19.
//

import XCTest
import RallyMock
import RallyCore
@testable import RallyData

final class QuestionAnswerAnswerQueueTests: XCTestCase {
    var queue: RallyData.QuestionAnswerRequestQueue!
    
    override func setUp() {
        super.setUp()
        
        queue = RallyData.QuestionAnswerRequestQueue()
        queue.clear()
    }
    
    func testAddAnswer() throws {
        let answer = try getQuestionAnswer()
        
        queue.add(answer: answer)
        
        XCTAssertTrue(queue.exists(questionNo: answer.questionNo))
    }
    
    func testAddAnswer_multipleIdenticalAdds() throws {
        let answer = try getQuestionAnswer()
        
        queue.add(answer: answer)
        queue.add(answer: answer)
        queue.add(answer: answer)
        
        XCTAssertTrue(queue.exists(questionNo: answer.questionNo))
        XCTAssertEqual(queue.getAll().count, 1)
    }
    
    func testRemoveAnswer_oneAdd() throws {
        let answer = try getQuestionAnswer()
        let questionNo = answer.questionNo
        
        queue.add(answer: answer)
        XCTAssertTrue(queue.exists(questionNo: questionNo))
        
        queue.remove(questionNo: questionNo)
        XCTAssertFalse(queue.exists(questionNo: questionNo))
    }
    
    func testRemoveAnswer_multipleAdd() throws {
        let answer = try getQuestionAnswer()
        let questionNo = answer.questionNo
        
        queue.add(answer: answer)
        XCTAssertTrue(queue.exists(questionNo: questionNo))
        
        queue.remove(questionNo: questionNo)
        XCTAssertFalse(queue.exists(questionNo: questionNo))
    }
    
    func testGetAll() throws {
        let answer = try getQuestionAnswer()
        var answer2 = try getQuestionAnswer()
        let questionNo2 = 1000
        answer2.questionNo = questionNo2

        queue.add(answer: answer)
        queue.add(answer: answer2)
        
        XCTAssertEqual([answer, answer2], queue.getAll())
    }
}

extension QuestionAnswerAnswerQueueTests {
    private func getQuestionAnswer() throws -> QuestionAnswer {
        let data = RallyMock.QuestionAnswerRequest.QuestionAnswer.valid
        
        return try Data(data.utf8).decoded() as QuestionAnswer
    }
}
