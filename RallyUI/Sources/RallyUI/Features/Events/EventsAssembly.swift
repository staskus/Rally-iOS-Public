import Foundation
import Swinject
import RallyCore

public class EventsAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(EventsConfigurator.self) { resolver in
            EventsConfigurator(
                userRepository: resolver.resolve(UserRepository.self)!,
                eventRepository: resolver.resolve(EventRepository.self)!,
                connectionWatcher: resolver.resolve(ConnectionWatcher.self)!
            )
        }
        .initCompleted{ (resolver, configurator) in
            configurator.questionsConfigurator = resolver.resolve(QuestionsConfigurator.self)
            configurator.loginConfigurator = resolver.resolve(LoginConfigurator.self)
        }
        .inObjectScope(.container)
    }
}
