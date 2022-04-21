import UIKit

class AnswerTimerRouter {
    weak var viewController: AnswerTimerViewController?
    private let onSuccess: () -> ()

    init(onSuccess: @escaping () -> ()) {
        self.onSuccess = onSuccess
    }

    func route(to route: AnswerTimer.Route) {
        switch route {
        case .question(_):
            viewController?.dismiss(animated: true, completion: { [weak self] in
                self?.onSuccess()
            })
        case .error:
            showError()
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: ~"answer_timer_error_title",
                                      message: ~"answer_timer_error_description",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { _ in
                                        self.viewController?.dismiss(animated: true, completion: nil)
        }))
        
        viewController?.present(alert, animated: true)
    }
}
