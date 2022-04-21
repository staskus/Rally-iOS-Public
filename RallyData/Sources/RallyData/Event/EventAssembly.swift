//
//  EventAssembly.swift
//  
//
//  Created by Povilas Staskus on 10/27/19.
//

import Foundation
import Swinject
import RallyCore

public class EventAssembly: Assembly {
    public init() {
    }
    
    public func assemble(container: Container) {
        container.register(LocalEventStore.self) { _ in
            return UserDefaultsEventStore()
        }.inObjectScope(.container)
        
        container.register(RallyCore.EventRepository.self) { _ in
            return EventRepository(apiClient: container.resolve(APIClient.self)!,
                                   localStore: container.resolve(LocalEventStore.self)!,
                                   userRepository: container.resolve(RallyCore.UserRepository.self)!)
        }.inObjectScope(.container)
    }
}
