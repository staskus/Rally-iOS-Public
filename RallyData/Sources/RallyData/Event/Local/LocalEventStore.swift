//
//  LocalEventStore.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation
import RallyCore

public protocol LocalEventStore {
    func getEvents() -> [Event]
    func save(events: [Event])
    func reset()
}
