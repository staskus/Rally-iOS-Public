import Foundation
import RallyCore

struct Login {
    struct Data: Equatable {
        var login: String = ""
        var password: String = ""
    }

    struct ViewModel: FeatureViewModel {
        let state: ViewState<Login.ViewModel.Content>
        let title: String

        struct Content: FeatureContentViewModel {
            let login: String
            let password: String
            let isLoginEnabled: Bool
        }
    }

    enum Action {
        case load
        case input(login: String, password: String)
        case login
    }

    enum Route {
        case forgotPassword
        case register
        case loginFinished
    }
}
