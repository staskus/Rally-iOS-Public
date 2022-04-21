import Foundation
import Swinject
import RallyCore

public class LoginAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(LoginConfigurator.self) { _ in
            LoginConfigurator(
                userRepository: container.resolve(UserRepository.self)!
            )
        }
        .initCompleted{ (resolver, configurator) in
            configurator.eventsConfigurator = resolver.resolve(EventsConfigurator.self)
        }
        .inObjectScope(.container)
    }
}
