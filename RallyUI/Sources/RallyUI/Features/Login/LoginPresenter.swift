import UIKit
import RallyCore

typealias LoginPresenter = FeaturePresenter<LoginViewController, LoginAdapter>

class LoginAdapter: FeatureAdapter {
    typealias Content = Login.Data
    typealias ViewModel = Login.ViewModel

    func makeViewModel(viewState: ViewState<Login.ViewModel.Content>) -> Login.ViewModel {
        return Login.ViewModel(
            state: viewState,
            title: ""
        )
    }

    func makeContentViewModel(content: Login.Data) throws -> Login.ViewModel.Content {
        let login = content.login
        let password = content.password
        return Login.ViewModel.Content(
            login: login,
            password: password,
            isLoginEnabled: !login.isEmpty && !password.isEmpty
        )
    }
}
