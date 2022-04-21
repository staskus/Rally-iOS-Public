//
//  QuestionAnswerRequest.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation
import RallyCore

public struct QuestionAnswerRequest: Codable, Equatable {
    public var answer: QuestionAnswer
    
    public init(answer: QuestionAnswer) {
        self.answer = answer
        self.answer.sendTimestamp = Date()
    }
}

public extension QuestionAnswerRequest {
    enum CodingKeys: String, CodingKey {
        case answer = "Answer"
    }
}
