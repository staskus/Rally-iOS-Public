import Foundation
import Swinject
import RallyCore

public class UserAssembly: Assembly {
    public init() {
    }
    
    public func assemble(container: Container) {
        container.register(LocalUserStore.self) { _ in
            return KeychainUserStore()
        }.inObjectScope(.container)
        
        container.register(RallyCore.UserRepository.self) { _ in
            return UserRepository(apiClient: container.resolve(APIClient.self)!,
                                  localStore: container.resolve(LocalUserStore.self)!,
                                  localEventStore: container.resolve(LocalEventStore.self)!,
                                  queue: container.resolve(RallyCore.QuestionAnswerRequestQueue.self)!)
        }.inObjectScope(.container)
    }
}
