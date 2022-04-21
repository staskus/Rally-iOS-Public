//
//  ViewTimeResponse.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation

public struct ViewTimeResponse: Codable, Equatable {
    public var result: ViewTimeResult
}

public extension ViewTimeResponse {
    enum CodingKeys: String, CodingKey {
        case result = "ViewTime"
    }
}

public struct ViewTimeResult: Codable, Equatable {
    public var sessionId: String
    public var eventId: String
    public var questionNo: Int
    public var result: String
    
    public var isAccepted: Bool {
        result == "Ok"
    }
}

public extension ViewTimeResult {
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case eventId = "EventId"
        case questionNo = "QNo"
        case result = "Result"
    }
}
