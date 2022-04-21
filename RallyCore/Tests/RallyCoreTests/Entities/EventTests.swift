//
//  EventTests.swift
//  RallyCoreTests
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import XCTest
@testable import RallyCore

class EventTests: XCTestCase {
    func testEventParsed_validUserData() throws {
        let validEventTestData =
        """
         {"Name":"Moterų ralis 2020","EventID":"9878","DateFrom":"2019-10-28T19:59:31+0000","DateTill":"2019-10-28T19:59:31+0000","CrewName":"Ladies on (w)heels","StNr.":"345"}
        """

        let event = try Data(validEventTestData.utf8).decoded() as Event

        let expectedEvent = Event(
            name: "Moterų ralis 2020",
            eventId: "9878",
            from: Date(timeIntervalSince1970: 1572292771.0),
            until: Date(timeIntervalSince1970: 1572292771.0),
            crewName: "Ladies on (w)heels",
            stNr: "345"
        )

        XCTAssertEqual(event, expectedEvent)
    }

    func testEventsParsed_validUserData() throws {
        let validEventTestData =
        """
        [{"Name":"Moterų ralis 2018","EventID":"9876","DateFrom":"2019-10-28T19:59:31+0000","DateTill":"2019-10-28T19:59:31+0000","CrewName":"Ladies on (w)heels","StNr.":"345"},
        {"Name":"Moterų ralis 2019","EventID":"9877","DateFrom":"2019-10-28T19:59:31+0000","DateTill":"2019-10-28T19:59:31+0000","CrewName":"Ladies on (w)heels","StNr.":"345"},
        {"Name":"Moterų ralis 2020","EventID":"9878","DateFrom":"2019-10-28T19:59:31+0000","DateTill":"2019-10-28T19:59:31+0000","CrewName":"Ladies on (w)heels","StNr.":"345"}]
        """

        let events = try Data(validEventTestData.utf8).decoded() as [Event]

        let expectedEvents = [
            Event(
                name: "Moterų ralis 2018",
                eventId: "9876",
                from: Date(timeIntervalSince1970: 1572292771.0),
                until: Date(timeIntervalSince1970: 1572292771.0),
                crewName: "Ladies on (w)heels",
                stNr: "345"
            ),
            Event(
                name: "Moterų ralis 2019",
                eventId: "9877",
                from: Date(timeIntervalSince1970: 1572292771.0),
                until: Date(timeIntervalSince1970: 1572292771.0),
                crewName: "Ladies on (w)heels",
                stNr: "345"
            ),
            Event(
                name: "Moterų ralis 2020",
                eventId: "9878",
                from: Date(timeIntervalSince1970: 1572292771.0),
                until: Date(timeIntervalSince1970: 1572292771.0),
                crewName: "Ladies on (w)heels",
                stNr: "345"
            )
        ]

        XCTAssertEqual(events, expectedEvents)
    }

    func testEventParsed_noEventId() {
        let validEventTestData =
        """
         {"Name":"Moterų ralis 2020","DateFrom":"2019-10-28T19:59:31+0000","DateTill":"2019-10-28T19:59:31+0000"}
        """

        let event = try? Data(validEventTestData.utf8).decoded() as Event

        XCTAssertEqual(event, nil)
    }
}
