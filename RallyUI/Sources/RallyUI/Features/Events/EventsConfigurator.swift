import UIKit
import RallyCore

public class EventsConfigurator {
    
    private let userRepository: UserRepository
    private let eventRepository: EventRepository
    private let connectionWatcher: ConnectionWatcher
    unowned var questionsConfigurator: QuestionsConfigurator!
    unowned var loginConfigurator: LoginConfigurator!

    public init(
        userRepository: UserRepository,
         eventRepository: EventRepository,
         connectionWatcher: ConnectionWatcher) {
        self.userRepository = userRepository
        self.eventRepository = eventRepository
        self.connectionWatcher = connectionWatcher
    }

    public func createViewController() -> UIViewController {
        let adapter = EventsAdapter()
        let presenter = EventsPresenter(adapter: adapter)
        let router = EventsRouter(questionsConfigurator: questionsConfigurator,
                                  loginConfigurator: loginConfigurator)
        let interactor = EventsInteractor(
            presenter: presenter,
            userRepository: userRepository,
            eventRepository: eventRepository,
            connectionWatcher: connectionWatcher,
            router: router
        )
        let viewController = EventsViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }
}
