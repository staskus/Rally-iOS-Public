import UIKit
import RxSwift
import RallyCore

protocol LoginInteractable {
    func dispatch(_ action: Login.Action)
}

class LoginInteractor: FeatureInteractor, LoginInteractable {
    private let presenter: LoginPresenter
    private let router: LoginRouter
    private let userRepository: UserRepository
    private var disposeBag = DisposeBag()

    private var contentState: ContentState<Login.Data> = .loading(data: nil) {
        didSet {
            guard contentState != oldValue else { return }
            presenter.present(contentState)
        }
    }

    init(presenter: LoginPresenter,
         router: LoginRouter,
         userRepository: UserRepository) {
        self.presenter = presenter
        self.router = router
        self.userRepository = userRepository
    }

    func dispatch(_ action: Login.Action) {
        switch action {
        case .load:
            load()
        case .input(let name, let password):
            inputChanged(login: name, password: password)
        case .login:
            login()
        }
    }

    func load() {
        disposeBag = DisposeBag()
        contentState = .loaded(data: Login.Data(), error: nil)
    }
    
    private func login() {
        let name = contentState.data?.login ?? ""
        let password = contentState.data?.password ?? ""
        
        contentState = .loading(data: contentState.data)
        
        userRepository
            .login(name: name, password: password)
            .subscribe(
                onNext: { _ in
                    self.router.route(to: .loginFinished)
            },
                onError: { [weak self] error in
                    if let data = self?.contentState.data {
                        if case APIClientError.failedStatus(401) = error {
                            self?.contentState = .loaded(data: data, error: .loading(reason: ~"login_wrong_credentials"))
                        } else {
                            self?.contentState = .loaded(data: data, error: .loading(reason: ~"login_retry"))
                        }
                    }
            })
            .disposed(by: disposeBag)
    }
    
    private func inputChanged(login: String, password: String) {
        contentState = .loaded(data: Login.Data(login: login, password: password), error: nil)
    }

    func subscribe() {
        presenter.present(contentState)
    }

    func unsubscribe() {
        disposeBag = DisposeBag()
    }
}
