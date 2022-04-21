//
//  EventResponse.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation
import RallyCore

public struct EventResponse: Decodable, Equatable {
    public var events: [Event]
}

public extension EventResponse {
    enum CodingKeys: String, CodingKey {
        case events = "Events"
    }
}
