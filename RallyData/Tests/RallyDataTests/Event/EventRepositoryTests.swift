//
//  EventRepositoryTests.swift
//  
//
//  Created by Povilas Staskus on 11/23/19.
//

import Foundation
import XCTest
import RallyCore
@testable import RallyData

final class EventRepositoryTests: XCTestCase {
    private var eventRepository: RallyData.EventRepository!
    var apiClient: APIClientSpy!
    var localEventDataStore: LocalEventStoreDataSpy!
    var userRepository: RallyCore.UserRepository!
    
    override func setUp() {
        super.setUp()
        
        apiClient = APIClientSpy()
        localEventDataStore = LocalEventStoreDataSpy()
        userRepository = UserRepositoryMock()
        
        eventRepository = RallyData.EventRepository(
            apiClient: apiClient,
            localStore: localEventDataStore,
            userRepository: userRepository
        )
    }
    
    // MARK: - Current Event
    
    func testGetCurrentEvent_firstEventFromYesterdayToTomorrow() {
        let event1 = createEvent(from: date(beforeDays: 1), until: date(afterDays: 1))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let currentEvent = eventRepository.getCurrentEvent(from: getCurrentDate())
        
        XCTAssertEqual(currentEvent, event1)
    }
    
    func testGetCurrentEvent_firstEventFromTodayToToday() {
        let event1 = createEvent(from: date(beforeDays: 0), until: date(afterDays: 0))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let currentEvent = eventRepository.getCurrentEvent(from: getCurrentDate())
        
        XCTAssertEqual(currentEvent, event1)
    }
    
    func testGetCurrentEvent_secondEventFromYesterdayToTomorrow() {
        let event1 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        let event2 = createEvent(from: date(beforeDays: 1), until: date(afterDays: 1))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let currentEvent = eventRepository.getCurrentEvent(from: getCurrentDate())
        
        XCTAssertEqual(currentEvent, event2)
    }
    
    func testGetCurrentEvent_allPastEvents() {
        let event1 = createEvent(from: date(beforeDays: 5), until: date(beforeDays: 4))
        let event2 = createEvent(from: date(beforeDays: 3), until: date(beforeDays: 1))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let currentEvent = eventRepository.getCurrentEvent(from: getCurrentDate())
        
        XCTAssertNil(currentEvent)
    }
    
    func testGetCurrentEvent_allFutureEvents() {
        let event1 = createEvent(from: date(afterDays: 4), until: date(afterDays: 5))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 3))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let currentEvent = eventRepository.getCurrentEvent(from: getCurrentDate())
        
        XCTAssertNil(currentEvent)
    }
    
    // MARK: - Next Event
    
    func testGetNextEvent_firstEventFromYesterdayToTomorrow() {
        let event1 = createEvent(from: date(beforeDays: 1), until: date(afterDays: 1))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertEqual(nextEvent, event2)
    }
    
    func testGetNextEvent_firstEventFromTodayToToday() {
        let event1 = createEvent(from: date(beforeDays: 0), until: date(afterDays: 0))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertEqual(nextEvent, event2)
    }
    
    func testGetNextEvent_secondEventFromYesterdayToTomorrow() {
        let event1 = createEvent(from: date(afterDays: 1), until: date(afterDays: 2))
        let event2 = createEvent(from: date(beforeDays: 1), until: date(afterDays: 1))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertEqual(nextEvent, event1)
    }
    
    func testGetNextEvent_allPastEvents() {
        let event1 = createEvent(from: date(beforeDays: 5), until: date(beforeDays: 4))
        let event2 = createEvent(from: date(beforeDays: 3), until: date(beforeDays: 1))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertNil(nextEvent)
    }
    
    func testGetNextEvent_allFutureEvents() {
        let event1 = createEvent(from: date(afterDays: 4), until: date(afterDays: 5))
        let event2 = createEvent(from: date(afterDays: 1), until: date(afterDays: 3))
        localEventDataStore.eventsToReturn = [event1, event2]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertEqual(nextEvent, event2)
    }
    
    func testGetNextEvent_pastEvents_currentEvent_futureEvents() {
        let event1 = createEvent(from: date(beforeDays: 5), until: date(beforeDays: 4))
        let event2 = createEvent(from: date(beforeDays: 3), until: date(beforeDays: 1))
        let event3 = createEvent(from: date(beforeDays: 1), until: date(afterDays: 1))
        let event4 = createEvent(from: date(afterDays: 1), until: date(afterDays: 3))
        let event5 = createEvent(from: date(afterDays: 10), until: date(afterDays: 10))

        localEventDataStore.eventsToReturn = [event1, event4, event5, event2, event3]
        
        let nextEvent = eventRepository.getNextEvent(from: getCurrentDate())
        
        XCTAssertEqual(nextEvent, event4)
    }
}

extension EventRepositoryTests {
    private func createEvent(from: Date, until: Date) -> Event {
        return Event(
            name: "",
            eventId: "",
            from: from,
            until: until,
            crewName: "",
            stNr: ""
        )
    }
    
    private func date(afterDays days: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(days * 60 * 60))
    }
    
    private func date(beforeDays days: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(-days * 60 * 60))
    }
    
    private func getCurrentDate() -> Date {
        return Date(timeIntervalSince1970: 0)
    }
}
