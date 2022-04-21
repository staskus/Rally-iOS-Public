//
//  QuestionAnswer.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation

public struct QuestionAnswer: Codable, Equatable {
    public var sessionId: String
    public var eventId: String
    public var questionNo: Int
    public var answerNo: Int?
    public var text: String?
    public var number: String?
    public var submitTimestamp: Date
    public var sendTimestamp: Date?
    
    public init(sessionId: String, eventId: String, questionNo: Int,
                answerNo: Int?, text: String?, number: String?,
                submitTimestamp: Date, sendTimestamp: Date?) {
        self.sessionId = sessionId
        self.eventId = eventId
        self.questionNo = questionNo
        self.answerNo = answerNo
        self.text = text
        self.number = number
        self.submitTimestamp = submitTimestamp
        self.sendTimestamp = sendTimestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sessionId = try container.decode(String.self, forKey: .sessionId)
        eventId = try container.decode(String.self, forKey: .eventId)
        questionNo = try container.decode(Int.self, forKey: .questionNo)
        answerNo = try? container.decodeIfPresent(Int.self, forKey: .answerNo)
        text = try? container.decodeIfPresent(String.self, forKey: .text)
        number = try? container.decodeIfPresent(String.self, forKey: .number)
        submitTimestamp = try container.decode(Date.self, forKey: .submitTimestamp)
        sendTimestamp = try? container.decodeIfPresent(Date.self, forKey: .sendTimestamp)
    }
}

public extension QuestionAnswer {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case eventId = "EventId"
        case questionNo = "QNo"
        case answerNo = "ANo"
        case number = "ANumber"
        case text = "AText"
        case submitTimestamp = "ASubmitTimestamp"
        case sendTimestamp = "ASendTimestamp"
    }
}
