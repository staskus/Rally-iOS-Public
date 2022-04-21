//
//  EventRequest.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation

public struct EventRequest: Codable, Equatable {
    public var events: Events
    
    public init (events: Events) {
        self.events = events
    }
}

public extension EventRequest {
    enum CodingKeys: String, CodingKey {
        case events = "Events"
    }
}

public struct Events: Codable, Equatable {
    public var sessionId: String
    
    public init (sessionId: String) {
        self.sessionId = sessionId
    }
}

public extension Events {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
    }
}
