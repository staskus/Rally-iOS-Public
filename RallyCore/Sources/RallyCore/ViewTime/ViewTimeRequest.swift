//
//  ViewTimeRequest.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation

public struct ViewTimeRequest: Codable, Equatable {
    private var viewTime: ViewTime
    
    public init(viewTime: ViewTime) {
        self.viewTime = viewTime
    }
}

public extension ViewTimeRequest {
    enum CodingKeys: String, CodingKey {
        case viewTime = "ViewTime"
    }
}

public struct ViewTime: Codable, Equatable {
    public var sessionId: String
    public var eventId: String
    public var questionNo: Int
    public var firstSeenTimestamp: Date
    
    public init(
        sessionId: String,
        eventId: String,
        questionNo: Int,
        firstSeenTimestamp: Date
    ) {
        self.sessionId = sessionId
        self.eventId = eventId
        self.questionNo = questionNo
        self.firstSeenTimestamp = firstSeenTimestamp
    }
}

public extension ViewTime {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case eventId = "EventId"
        case questionNo = "QNo"
        case firstSeenTimestamp = "AFirstSeenTimestamp"
    }
}
