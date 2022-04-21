//
//  EventRepository.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation
import RxSwift
import RallyCore

public class EventRepository: RallyCore.EventRepository {
    private let apiClient: RallyCore.APIClient
    private let localStore: LocalEventStore
    private let userRepository: RallyCore.UserRepository
    
    init(apiClient: RallyCore.APIClient,
         localStore: LocalEventStore,
         userRepository: RallyCore.UserRepository) {
        self.apiClient = apiClient
        self.localStore = localStore
        self.userRepository = userRepository
    }
    
    public func loadEvents() -> Observable<[RallyCore.Event]> {
        guard let sessionId = userRepository.getUser()?.sessionId else {
            return .error( UserError.noSessionId)
        }
        
        let eventRequest = EventRequest(events:
            Events(sessionId: sessionId)
        )
        
        let eventResponse: Observable<EventResponse> = apiClient.post(path: "events", request: eventRequest)
        
        return eventResponse
            .map { $0.events }
            .do(onNext: {
                self.localStore.save(events: $0)
            })
    }
    
    public func getEvents() -> [RallyCore.Event] {
        return localStore.getEvents()
    }
    
    public func getTimeUntil(event: RallyCore.Event) -> TimeInterval {
        return event.from.timeIntervalSince1970 - Date().timeIntervalSince1970
    }
    
    public func getCurrentEvent() -> RallyCore.Event? {
        return getCurrentEvent(from: Date())
    }
    
    func getCurrentEvent(from date: Date) -> RallyCore.Event? {
        // HERE
//        return getEvents().first
        return getEvents().first(where: { event in
            let currentTimeInterval = date.timeIntervalSince1970
            let dateFrom = event.from.timeIntervalSince1970
            let dateTo = event.until.timeIntervalSince1970
            
            return currentTimeInterval >= dateFrom
                && currentTimeInterval <= dateTo
        })
    }
    
    public func getNextEvent() -> RallyCore.Event? {
        return getNextEvent(from: Date())
    }
    
    func getNextEvent(from date: Date) -> RallyCore.Event? {
        return getEvents()
            .filter { event in
                let currentTimeInterval = date.timeIntervalSince1970
                let dateFrom = event.from.timeIntervalSince1970
                return currentTimeInterval < dateFrom
            }
            .sorted(by: { (event1, event2) in
                return event1.from.timeIntervalSince1970 <  event2.from.timeIntervalSince1970
            })
            .first
    }
}
