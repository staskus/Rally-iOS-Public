import Foundation
import Swinject
import RallyCore

public class AnswerTimerAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(AnswerTimerConfigurator.self) { resolver in
            AnswerTimerConfigurator(viewTimeRepository: resolver.resolve(ViewTimeRepository.self)!)
        }.inObjectScope(.container)
    }
}
