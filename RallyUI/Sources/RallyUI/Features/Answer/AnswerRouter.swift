import UIKit

class AnswerRouter {
    weak var viewController: AnswerViewController?

    init() {
    }

    func route(to route: Answer.Route) {
        switch route {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
