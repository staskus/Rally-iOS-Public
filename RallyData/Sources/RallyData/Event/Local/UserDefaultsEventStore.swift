//
//  UserDefaultsEventStore.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation
import RallyCore

public class UserDefaultsEventStore: LocalEventStore {
    private let defaults: UserDefaults = .standard
    private let key = "events.key"
    
    public func getEvents() -> [Event] {
        guard let data = defaults.object(forKey: key) as? Data else {
            return []
        }
        
        return (try? PropertyListDecoder().decode([Event].self, from: data)) ?? []
    }
    
    public func save(events: [Event]) {
        defaults.set(try? PropertyListEncoder().encode(events), forKey: key)
        defaults.synchronize()
    }
    
    public func reset() {
        defaults.set(nil, forKey: key)
        defaults.synchronize()
    }
}
