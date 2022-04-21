//
//  QuestionAnswerResult.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation

public struct QuestionAnswerResult: Codable, Equatable {
    public var sessionId: String?
    public var eventId: String?
    public var result: String
    
    public var isAccepted: Bool {
        return result == "Ok"
    }
}

public extension QuestionAnswerResult {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case eventId = "EventId"
        case result = "Result"
    }
}
