//
//  LocalEventStoreDataSpy.swift
//  
//
//  Created by Povilas Staskus on 11/14/19.
//

import Foundation
import RallyCore
@testable import RallyData

class LocalEventStoreDataSpy: LocalEventStore {
    var eventsToReturn: [Event] = []
    
    func getEvents() -> [Event] {
        return eventsToReturn
    }
    
    func save(events: [Event]) {
    }
    
    func reset() {
    }
}
