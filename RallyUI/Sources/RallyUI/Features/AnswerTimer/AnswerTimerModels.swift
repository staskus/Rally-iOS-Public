import Foundation
import RallyCore

struct AnswerTimer {
    struct Data: Equatable {
        let question: Question
        let event: Event
        let time: String
    }

    struct ViewModel: FeatureViewModel {
        let state: ViewState<AnswerTimer.ViewModel.Content>

        struct Content: FeatureContentViewModel {
            let title: String
            let time: String
        }
    }

    enum Action {
        case load
    }

    enum Route {
        case question(Question)
        case error
    }
}
