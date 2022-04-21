import Foundation
import Swinject
import RallyCore

public class QuestionsAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(QuestionsConfigurator.self) { resolver in
            QuestionsConfigurator(
                userRepository: resolver.resolve(UserRepository.self)!,
                eventRepository: resolver.resolve(EventRepository.self)!,
                questionsRepository: resolver.resolve(QuestionsRepository.self)!,
                permissionHander: PermissionHandler(),
                locationHandler: resolver.resolve(LocationHandlerProtocol.self)!,
                questionAnswerQueue: resolver.resolve(QuestionAnswerRequestQueue.self)!,
                connectionWatcher: resolver.resolve(ConnectionWatcher.self)!
            )
        }
        .initCompleted { resolver, configurator in
            configurator.loginConfigurator = resolver.resolve(LoginConfigurator.self)!
            configurator.answerConfigurator = resolver.resolve(AnswerConfigurator.self)!
            configurator.answerTimerConfigurator = resolver.resolve(AnswerTimerConfigurator.self)!
        }
        .inObjectScope(.container)
        
        container.register(LocationHandlerProtocol.self) { resolver in
            LocationHandler()
        }
        .inObjectScope(.container)
    }
}
