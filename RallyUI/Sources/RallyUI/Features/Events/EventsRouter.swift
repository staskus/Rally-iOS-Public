import UIKit

class EventsRouter {
    weak var viewController: EventsViewController?
    unowned let questionsConfigurator: QuestionsConfigurator
    unowned let loginConfigurator: LoginConfigurator

    init(questionsConfigurator: QuestionsConfigurator,
         loginConfigurator: LoginConfigurator) {
        self.questionsConfigurator = questionsConfigurator
        self.loginConfigurator = loginConfigurator
    }
    
    func route(to route: Events.Route) {
        switch route {
        case .event(let user, let event):
            let questionsVC = questionsConfigurator.createViewController(user: user, event: event)
            viewController?.navigationController?.pushViewController(questionsVC, animated: true)
        case .logout:
            UIApplication.shared.keyWindow?.rootViewController = loginConfigurator.createViewController()
        }
    }
}
