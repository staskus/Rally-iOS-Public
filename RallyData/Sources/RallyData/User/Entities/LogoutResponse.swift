//
//  LogoutResponse.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation

public enum LogoutError: Error {
    case unknown
}

public struct LogoutResponse: Codable, Equatable {
    public var logoutSession: LogoutResponseSession
    
    public init(logoutSession: LogoutResponseSession) {
        self.logoutSession = logoutSession
    }
}

public extension LogoutResponse {
    enum CodingKeys: String, CodingKey {
        case logoutSession = "Logout"
    }
}

public struct LogoutResponseSession: Codable, Equatable {
    public var sessionId: String
    public var result: String
    
    var isAccepted: Bool {
        return result == "Ok"
    }
    
    public init(sessionId: String, result: String) {
        self.sessionId = sessionId
        self.result = result
    }
}

public extension LogoutResponseSession {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case result = "Result"
    }
}
