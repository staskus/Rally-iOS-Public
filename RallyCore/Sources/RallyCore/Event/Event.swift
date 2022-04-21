//
//  Event.swift
//  RallyCore
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation

public struct Event: Codable, Equatable {
    public var name: String
    public var eventId: String
    public var from: Date
    public var until: Date
    public var crewName: String
    public var stNr: String
    
    public init(
        name: String,
        eventId: String,
        from: Date,
        until: Date,
        crewName: String,
        stNr: String
    ) {
        self.name = name
        self.eventId = eventId
        self.from = from
        self.until = until
        self.crewName = crewName
        self.stNr = stNr
    }
}

public extension Event {
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case eventId = "EventID"
        case from = "DateFrom"
        case until = "DateTill"
        case crewName = "CrewName"
        case stNr = "StNr."
    }
}
