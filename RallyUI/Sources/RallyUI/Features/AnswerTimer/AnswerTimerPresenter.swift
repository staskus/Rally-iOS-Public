import UIKit
import RallyCore

typealias AnswerTimerPresenter = FeaturePresenter<AnswerTimerViewController, AnswerTimerAdapter>

class AnswerTimerAdapter: FeatureAdapter {
    typealias Content = AnswerTimer.Data
    typealias ViewModel = AnswerTimer.ViewModel

    func makeViewModel(viewState: ViewState<AnswerTimer.ViewModel.Content>) -> AnswerTimer.ViewModel {
        return AnswerTimer.ViewModel(
            state: viewState
        )
    }

    func makeContentViewModel(content: AnswerTimer.Data) throws -> AnswerTimer.ViewModel.Content {
        return AnswerTimer.ViewModel.Content(title: getTitle(from: content.event),
                                             time: content.time)
    }
    
    private func getTitle(from event: Event) -> String {
        return event.name
    }
}
