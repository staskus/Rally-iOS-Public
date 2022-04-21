import UIKit
import RallyCore

public class AnswerTimerConfigurator {
    private let viewTimeRepository: ViewTimeRepository

    public init(viewTimeRepository: ViewTimeRepository) {
        self.viewTimeRepository = viewTimeRepository
    }

    public func createViewController(question: RallyCore.Question,
                                     event: RallyCore.Event,
                                     user: RallyCore.User,
                                     onSuccess: @escaping () -> ()) -> UIViewController {
        let adapter = AnswerTimerAdapter()
        let presenter = AnswerTimerPresenter(adapter: adapter)
        let router = AnswerTimerRouter(onSuccess: onSuccess)
        let interactor = AnswerTimerInteractor(presenter: presenter,
                                               router: router,
                                               question: question,
                                               event: event,
                                               user: user,
                                               viewTimeRepository: viewTimeRepository)
        let viewController = AnswerTimerViewController(interactor: interactor, router: router)
        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }
}
