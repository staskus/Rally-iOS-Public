import Foundation
import Swinject
import RallyCore

public class AnswerAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(AnswerConfigurator.self) { resolver in
            AnswerConfigurator(
                questionAnswerRepository: resolver.resolve(QuestionAnswerRepository.self)!,
                questionAnswerRequestQueue: resolver.resolve(QuestionAnswerRequestQueue.self)!,
                connectionWatcher: resolver.resolve(ConnectionWatcher.self)!,
                locationHandler: resolver.resolve(LocationHandlerProtocol.self)!
            )
        }.inObjectScope(.container)
    }
}
