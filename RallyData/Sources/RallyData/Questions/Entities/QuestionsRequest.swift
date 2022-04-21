//
//  QuestionsRequest.swift
//  
//
//  Created by Povilas Staskus on 10/29/19.
//

import Foundation

public struct QuestionsRequest: Codable, Equatable {
    public var questions: QuestionsSession
    
    public init (questions: QuestionsSession) {
        self.questions = questions
    }
}

public extension QuestionsRequest {
    enum CodingKeys: String, CodingKey {
        case questions = "Questions"
    }
}

public struct QuestionsSession: Codable, Equatable {
    public var sessionId: String
    public var eventId: String
    
    public init (sessionId: String, eventId: String) {
        self.sessionId = sessionId
        self.eventId = eventId
    }
}

public extension QuestionsSession {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case eventId = "EventID"
    }
}
