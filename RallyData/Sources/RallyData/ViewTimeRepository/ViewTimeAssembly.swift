//
//  ViewTimeAssembly.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import Swinject
import RallyCore

public class ViewTimeAssembly: Assembly {
    public init() {
    }
    
    public func assemble(container: Container) {
        container.register(RallyCore.ViewTimeRepository.self) { _ in
            return ViewTimeRepository(apiClient: container.resolve(APIClient.self)!)
        }.inObjectScope(.container)
        
        container.register(RallyCore.ViewTimeRequestQueue.self) { _ in
            return ViewTimeRequestQueue()
        }.inObjectScope(.container)
        
        container.register(RallyCore.ViewTimeRequestQueueListener.self) { _ in
            return ViewTimeRequestQueueListener(
                queue: container.resolve(RallyCore.ViewTimeRequestQueue.self)!,
                repository: container.resolve(RallyCore.ViewTimeRepository.self)!,
                connectionWatcher: container.resolve(RallyCore.ConnectionWatcher.self)!
            )
        }.inObjectScope(.container)
    }
}
