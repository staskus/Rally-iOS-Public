import UIKit
import SnapKit
import RxCocoa

class LoginViewController: UIViewController, FeatureViewController {

    // View Model
    var viewModel: Login.ViewModel?
    typealias ViewModel = Login.ViewModel
    typealias Interactor = LoginInteractor & LoginInteractable

    // State Views
    var errorView: UIView?
    var loadingView: UIView?
    var emptyView: UIView?
    var alertViewController: UIViewController?

    // Properties
    private let interactor: Interactor
    private let router: LoginRouter
    
    // UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let logo = UIImageView()
    private let titleLabel = UILabel()
    private let loginTextField = CommonTextField()
    private let passwordTextField = CommonTextField()
    private let loginButton = UIButton()
    private let forgotPasswordButton = UIButton()
    private let registerButton = UIButton()

    init(interactor: Interactor, router: LoginRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStateViews()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor.subscribe()

        interactor.dispatch(Login.Action.load)
        
        registerKeyboardEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        interactor.unsubscribe()
        
        unregisterKeyboardEvents()
    }

    func display() {
        guard let viewModel = viewModelState?.viewModel else { return }
        
        loginButton.isEnabled = viewModel.isLoginEnabled
    }
    
    func reload() {
        interactor.dispatch(.load)
    }
    
    // MARK: - Keyboard Events
    
    override func keyboardWillAppear(_ keyboardHeight: CGFloat) {
        scrollView.contentInset.bottom = keyboardHeight
    }
    
    override func keyboardWillDisappear() {
        scrollView.contentInset.bottom = 0
    }

    // MARK: - Required Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginViewController {
    private func setupView() {
        view.backgroundColor = Theme.backgroundColor
        
        view.addSubviews(
            scrollView.style(scrollViewStyle).addSubviews(
                stackView.style(stackStyle)
            ),
            registerButton.style(Style.Button.link).style(registerButtonStyle)
        )
        
        let views = [
            logo.style(Style.Image.scaleAspectFit).style(logoStyle),
            titleLabel.style(Style.Label.medium).style(titleStyle),
            loginTextField.style(loginTextFieldStyle),
            passwordTextField.style(passwwordTextFieldStyle),
            loginButton.style(Style.Button.main).style(loginButtonStyle),
            forgotPasswordButton.style(Style.Button.link).style(forgotPasswordButtonStyle),
        ]
        
        views.forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(registerButton.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(view.snp.width).multipliedBy(0.85)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges).inset(UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0))
            make.width.equalTo(scrollView.snp.width)
        }
                
        logo.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.width.equalTo(stackView.snp.width)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(286)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
            make.leading.equalTo(stackView.snp.leading)
            make.trailing.equalTo(stackView.snp.trailing)
            make.height.equalTo(32)
        }
        
        stackView.setCustomSpacing(8, after: logo)
        stackView.setCustomSpacing(48, after: titleLabel)
        stackView.setCustomSpacing(20, after: loginTextField)
        stackView.setCustomSpacing(28, after: passwordTextField)
        stackView.setCustomSpacing(20, after: loginButton)
    }
    
    @objc
    private func endEditing() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    @objc
    private func textFieldValueChanged() {
        let loginText = loginTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        interactor.dispatch(.input(login: loginText, password: passwordText))
    }
    
    @objc
    private func loginButtonPressed() {
        interactor.dispatch(.login)
    }
}

extension LoginViewController {
    private func scrollViewStyle(_ scrollView: UIScrollView) {
        scrollView.delaysContentTouches = false
    }
    
    private func stackStyle(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
    }
    
    private func logoStyle(_ imageView: UIImageView) {
        imageView.image = UIImage(named: "LoginLogo")
    }
    
    private func titleStyle(_ label: UILabel) {
        label.text = ~"login_title"
    }
    
    private func loginTextFieldStyle(_ textField: CommonTextField) {
        textField.placeholder = ~"login_email_hint"
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    private func passwwordTextFieldStyle(_ textField: CommonTextField) {
        textField.placeholder = ~"login_password_hint"
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
    }
    
    private func forgotPasswordButtonStyle(_ button: UIButton) {
        button.setTitle(~"login_forgot_password", for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordPressed), for: .touchUpInside)
    }
    
    private func loginButtonStyle(_ button: UIButton) {
        button.setTitle(~"login_button", for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }

    private func registerButtonStyle(_ button: UIButton) {
        button.setTitle(~"login_registration", for: .normal)
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
    }
}

extension LoginViewController {
    @objc
    private func registerPressed() {
        router.route(to: .register)
    }
    
    @objc
    private func forgotPasswordPressed() {
        router.route(to: .forgotPassword)
    }
}

