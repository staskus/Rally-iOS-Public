import UIKit
import RallyCore

public class QuestionsConfigurator {
    private let userRepository: UserRepository
    private let eventRepository: EventRepository
    private let questionsRepository: QuestionsRepository
    private let permissionHander: PermissionHandler
    private let locationHandler: LocationHandlerProtocol
    private let questionAnswerQueue: QuestionAnswerRequestQueue
    private let connectionWatcher: ConnectionWatcher
    unowned var loginConfigurator: LoginConfigurator!
    unowned var answerConfigurator: AnswerConfigurator!
    unowned var answerTimerConfigurator: AnswerTimerConfigurator!
    
    
    public init(userRepository: UserRepository,
                eventRepository: EventRepository,
                questionsRepository: QuestionsRepository,
                permissionHander: PermissionHandler,
                locationHandler: LocationHandlerProtocol,
                questionAnswerQueue: QuestionAnswerRequestQueue,
                connectionWatcher: ConnectionWatcher) {
        self.userRepository = userRepository
        self.eventRepository = eventRepository
        self.questionsRepository = questionsRepository
        self.permissionHander = permissionHander
        self.locationHandler = locationHandler
        self.questionAnswerQueue = questionAnswerQueue
        self.connectionWatcher = connectionWatcher
    }

    public func createViewController(user: User, event: Event) -> UIViewController {
        let adapter = QuestionsAdapter()
        let presenter = QuestionsPresenter(adapter: adapter)
        let router = QuestionsRouter(
            loginConfigurator: loginConfigurator,
            answerConfigurator: answerConfigurator,
            answerTimerConfigurator: answerTimerConfigurator)
        let interactor = QuestionsInteractor(
            presenter: presenter,
            router: router,
            userRepository: userRepository,
            eventRepository: eventRepository,
            questionsRepository: questionsRepository,
            permissionHandler: permissionHander,
            locationHandler: locationHandler,
            questionAnswerQueue: questionAnswerQueue,
            connectionWatcher: connectionWatcher,
            user: user,
            event: event
        )
        let viewController = QuestionsViewController(interactor: interactor, router: router)

        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }
}
