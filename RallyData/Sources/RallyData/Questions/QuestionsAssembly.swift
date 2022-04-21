//
//  QuestionsAssembly.swift
//  
//
//  Created by Povilas Staskus on 10/29/19.
//

import Foundation
import Swinject
import RallyCore

public class QuestionsAssembly: Assembly {
    public init() {
    }
    
    public func assemble(container: Container) {
        container.register(RallyCore.QuestionsRepository.self) { _ in
            return QuestionsRepository(apiClient: container.resolve(APIClient.self)!,
                                       userRepository: container.resolve(RallyCore.UserRepository.self)!,
                                       queue: container.resolve(RallyCore.QuestionAnswerRequestQueue.self)!)
        }.inObjectScope(.container)
    }
}
