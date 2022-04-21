//
//  QuestionAnswerAssembly.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation
import Swinject
import RallyCore

public class QuestionAnswerAssembly: Assembly {
    public init() {
    }
    
    public func assemble(container: Container) {
        container.register(RallyCore.QuestionAnswerRepository.self) { _ in
            return QuestionAnswerRepository(apiClient: container.resolve(APIClient.self)!)
        }.inObjectScope(.container)
        
        container.register(RallyCore.QuestionAnswerRequestQueue.self) { _ in
            return QuestionAnswerRequestQueue()
        }.inObjectScope(.container)
        
        container.register(RallyCore.QuestionAnswerRequestQueueListener.self) { _ in
            return QuestionAnswerRequestQueueListener(
                queue: container.resolve(RallyCore.QuestionAnswerRequestQueue.self)!,
                repository: container.resolve(RallyCore.QuestionAnswerRepository.self)!,
                connectionWatcher: container.resolve(RallyCore.ConnectionWatcher.self)!
            )
        }.inObjectScope(.container)
    }
}
