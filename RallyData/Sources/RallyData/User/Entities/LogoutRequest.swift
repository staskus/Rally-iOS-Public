//
//  LogoutRequest.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation

public struct LogoutRequest: Codable, Equatable {
    public var logoutSession: LogoutSession
    
    public init(logoutSession: LogoutSession) {
        self.logoutSession = logoutSession
    }
}

public extension LogoutRequest {
    enum CodingKeys: String, CodingKey {
        case logoutSession = "Logout"
    }
}

public struct LogoutSession: Codable, Equatable {
    public var sessionId: String
    
    public init(sessionId: String) {
        self.sessionId = sessionId
    }
}

public extension LogoutSession {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
    }
}
