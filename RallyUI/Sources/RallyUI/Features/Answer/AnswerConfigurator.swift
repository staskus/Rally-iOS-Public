import UIKit
import RallyCore

public class AnswerConfigurator {
    private let questionAnswerRepository: QuestionAnswerRepository
    private let questionAnswerRequestQueue: QuestionAnswerRequestQueue
    private let connectionWatcher: ConnectionWatcher
    private let locationHandler: LocationHandlerProtocol

    public init(
        questionAnswerRepository: QuestionAnswerRepository,
        questionAnswerRequestQueue: QuestionAnswerRequestQueue,
        connectionWatcher: ConnectionWatcher,
        locationHandler: LocationHandlerProtocol
    ) {
        self.questionAnswerRepository = questionAnswerRepository
        self.questionAnswerRequestQueue = questionAnswerRequestQueue
        self.connectionWatcher = connectionWatcher
        self.locationHandler = locationHandler
    }

    public func createViewController(
        question: RallyCore.Question,
        user: RallyCore.User,
        event: RallyCore.Event
    ) -> UIViewController {
        let adapter = AnswerAdapter()
        let presenter = AnswerPresenter(adapter: adapter)
        let router = AnswerRouter()
        let interactor = AnswerInteractor(
            presenter: presenter,
            questionAnswerRepository: questionAnswerRepository,
            router: router,
            questionAnswerRequestQueue: questionAnswerRequestQueue,
            connectionWatcher: connectionWatcher,
            locationHandler: locationHandler,
            question: question,
            event: event,
            user: user)
        let viewController = AnswerViewController(
            interactor: interactor,
            router: router
        )

        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }
}
