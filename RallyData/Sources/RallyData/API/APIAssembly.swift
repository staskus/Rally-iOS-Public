import Foundation
import RallyCore
import Swinject

public class APIAssembly: Assembly {
    private let baseUrl: String
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func assemble(container: Container) {
        container.register(APIClient.self) { _ in
            return APIClient(baseUrl: self.baseUrl)
        }.inObjectScope(.container)
        
        container.register(RallyCore.ConnectionWatcher.self) { _ in
            return ConnectionWatcher()
        }.inObjectScope(.container)
    }
}
