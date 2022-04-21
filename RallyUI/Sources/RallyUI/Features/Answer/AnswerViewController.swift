import UIKit
import SnapKit
import Kingfisher
import RxSwift

class AnswerViewController: UIViewController, FeatureViewController {
    
    // View Model
    var viewModel: Answer.ViewModel?
    typealias ViewModel = Answer.ViewModel
    typealias Interactor = AnswerInteractor & AnswerInteractable
    
    // State Views
    var errorView: UIView?
    var loadingView: UIView?
    var emptyView: UIView?
    var alertViewController: UIViewController?
    
    // Properties
    private let interactor: Interactor
    private let router: AnswerRouter
    
    // UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let titleSeparator = UIView()
    private let questionLabel = UILabel()
    private let questionSeparator = UIView()
    private let textField = CommonTextField()
    private let choiceView =  AnswerChoicesView()
    private let submitButton = UIButton()
    private let disposeBag = DisposeBag()
    
    init(interactor: Interactor, router: AnswerRouter) {
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
        
        interactor.dispatch(Answer.Action.load)
        
        registerKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
        
        unregisterKeyboardEvents()
    }
    
    override func keyboardWillAppear(_ keyboardHeight: CGFloat) {
        scrollView.contentInset.bottom = keyboardHeight
    }
    
    override func keyboardWillDisappear() {
        scrollView.contentInset.bottom = 0
    }
    
    func display() {
        guard let viewModel = viewModelState?.viewModel else { return }
        
        configureImageView(viewModel)
        titleLabel.text = viewModel.title
        questionLabel.text = viewModel.question
        configureAnswerType(viewModel)
        showNoConnectionAlertIfNeeded(viewModel)
        navigationItem.title = viewModel.eventName
    }
    
    func reload() {
        interactor.dispatch(.load)
    }
    
    // MARK: - Required Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnswerViewController {
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: ~"back", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubviews(
            scrollView.style(scrollViewStyle).addSubviews(
                stackView.style(stackViewStyle)
            )
        )
        
        let views = [
            imageView.style(Style.Image.scaleAspectFit),
            titleLabel.style(titleLabelStyle),
            titleSeparator.style(separatorStyle),
            questionLabel.style(questionLabelStyle),
            questionSeparator.style(separatorStyle),
            textField.style(textFieldStyle).style { $0.isHidden = true },
            choiceView.style { $0.isHidden = true },
            submitButton.style(Style.Button.main).style(submitButtonStyle),
        ]
        
        views.forEach {
            stackView.addArrangedSubview($0)
        }
        
        choiceView.delegate = self
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(Theme.Padding.trailing)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing).offset(Theme.Padding.trailing)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing).offset(Theme.Padding.trailing)
        }
        
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(286)
        }
        
        titleSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
        
        questionSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing).offset(Theme.Padding.trailing)
        }
        
        choiceView.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(Theme.Padding.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
    }
}

extension AnswerViewController {
    private func configureImageView(_ viewModel: Answer.ViewModel.ContentViewModel) {
        imageView.kf.setImage(with: viewModel.imageUrl) { _ in
            guard let image = self.imageView.image else { return }
            
            let aspectRatio = image.size.width / image.size.height
            self.imageView.snp.makeConstraints { make in
                make.height.equalTo(self.imageView.snp.width).dividedBy(aspectRatio)
            }
        }
    }
    
    private func configureAnswerType(_ viewModel: Answer.ViewModel.ContentViewModel) {
        switch viewModel.type {
        case .choice(let choices):
            configureChoicesView(choices)
        case .text(let value):
            configureAlphanumericTextView(value)
        case .number(let value):
            configureNumberView(value)
        case .decimal(let value):
            configureDecimalView(value)
        }
    }
    
    private func configureChoicesView(_ choices: [Answer.ViewModel.ContentViewModel.QuestionType.Choice]) {
        choiceView.isHidden = false
        choiceView.choices = choices
        submitButton.isEnabled = !choices.map { $0.selected ?? false }.isEmpty
    }
    
    private func configureAlphanumericTextView(_ value: String?) {
        textField.isHidden = false
        
        textField.text = value
        textFieldValueChanged()
        textField.keyboardType = .alphabet
    }
    
    private func configureNumberView(_ value: String?) {
        textField.isHidden = false

        textField.keyboardType = .numberPad
        textField.text = value
        textFieldValueChanged()
    }
    
    private func configureDecimalView(_ value: String?) {
        textField.isHidden = false

        textField.keyboardType = .decimalPad
        textField.text = value
        textFieldValueChanged()
    }
}

extension AnswerViewController: AnswerChoicesViewDelegate {
    func answerChoicesView(_ view: AnswerChoicesView, didSelectChoiceAtIndex index: Int) {
        guard case let .choice(choices) = viewModel?.state.viewModel?.type else { return }
        
        interactor.dispatch(.selectChoice(choices[index].id))
    }
}

extension AnswerViewController {
    private func scrollViewStyle(_ scrollView: UIScrollView) {
        scrollView.delaysContentTouches = false
    }
    
    private func stackViewStyle(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
    }
    
    private func textFieldStyle(_ textField: CommonTextField) {
        textField.placeholder = ~"answer_hint"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = Theme.backgroundColor
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func titleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.textColor = Theme.primary
        label.numberOfLines = 0
    }
    
    private func questionLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = Theme.primary
        label.numberOfLines = 0
    }
    
    private func submitButtonStyle(_ button: UIButton) {
        button.setTitle(~"answer_details_save_button", for: .normal)
        button.isEnabled = false
        button.rx.tap
            .subscribe(
                onNext: { [unowned self] in
                    if self.interactor.cannotAnswerMoreThanOnce() {
                        self.showCannotAnswerMoreThanOnceAlert()
                    } else if !self.interactor.isInCorrectLocation() {
                        self.showIncorrectLocationAlert()
                    } else {
                        self.interactor.dispatch(.submit(self.textField.text))
                    }
            })
            .disposed(by: disposeBag)
    }
    
    private func separatorStyle(_ view: UIView) {
        view.backgroundColor = Theme.separatorColor
    }
}

extension AnswerViewController {
    private func showNoConnectionAlertIfNeeded(_ viewModel: Answer.ViewModel.ContentViewModel) {
        if viewModel.showSavedNoConnectionAlert {
            showNoConnetionSavedAlert()
        }
    }
    
    private func showNoConnetionSavedAlert() {
        let alert = UIAlertController(
            title: ~"questions_no_internet_done_alert_title",
            message: ~"questions_no_internet_done_alert_description",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { [unowned self] _ in
                self.router.route(to: .back)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension AnswerViewController {
    @objc
    private func textFieldValueChanged() {
        submitButton.isEnabled = !(textField.text ?? "").isEmpty
    }
}

extension AnswerViewController {
    private func showIncorrectLocationAlert() {
        let alert = UIAlertController(
            title: ~"answer_location_alert_title",
            message: ~"answer_location_alert_description",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        )
        
        present(alert, animated: true, completion: nil)
    }
}

extension AnswerViewController {
    private func showCannotAnswerMoreThanOnceAlert() {
        let alert = UIAlertController(
            title: ~"answer_location_alert_title",
            message: ~"answer_details_alert_answer_once",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        )
        
        present(alert, animated: true, completion: nil)
    }
}
