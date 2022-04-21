import UIKit
import RallyCore

public class LoginConfigurator {

    private let userRepository: UserRepository
    unowned var eventsConfigurator: EventsConfigurator!
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func createViewController() -> UIViewController {
        let adapter = LoginAdapter()
        let presenter = LoginPresenter(adapter: adapter)
        let router = LoginRouter(eventsConfigurator: eventsConfigurator)
        let interactor = LoginInteractor(
            presenter: presenter,
            router: router,
            userRepository: userRepository)
        let viewController = LoginViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }
}
