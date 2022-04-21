import UIKit
import RallyCore

class QuestionsRouter {
    weak var viewController: QuestionsViewController?
    unowned let loginConfigurator: LoginConfigurator
    unowned let answerConfigurator: AnswerConfigurator
    unowned let answerTimerConfigurator: AnswerTimerConfigurator

    init(loginConfigurator: LoginConfigurator,
         answerConfigurator: AnswerConfigurator,
         answerTimerConfigurator: AnswerTimerConfigurator) {
        self.loginConfigurator = loginConfigurator
        self.answerConfigurator = answerConfigurator
        self.answerTimerConfigurator = answerTimerConfigurator
    }
    
    func route(to route: Questions.Route) {
        switch route {
        case .logout:
            UIApplication.shared.keyWindow?.rootViewController = loginConfigurator.createViewController()
        case let .select(question, event, user):
            if shouldShowTimer(question) {
                let timerViewController = answerTimerConfigurator.createViewController(question: question, event: event, user: user) { [unowned self] in
                    self.viewController?.show(self.answerConfigurator.createViewController(
                        question: question,
                        user: user,
                        event: event), sender: nil)
                }
                let navigationController = BaseNavigationViewController(rootViewController: timerViewController)
                navigationController.modalPresentationStyle = .fullScreen
                viewController?.present(navigationController, animated: true, completion: nil)
            } else {
                viewController?.show(answerConfigurator.createViewController(
                    question: question,
                    user: user,
                    event: event), sender: nil)
            }
        case .settings:
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func shouldShowTimer(_ question: RallyCore.Question) -> Bool {
        return question.isSavingFirstSeenTime && question.firstSeenTimestamp == nil
    }
}
