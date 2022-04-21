import UIKit
import SnapKit

class AnswerTimerViewController: UIViewController, FeatureViewController {
    
    // View Model
    var viewModel: AnswerTimer.ViewModel?
    typealias ViewModel = AnswerTimer.ViewModel
    typealias Interactor = AnswerTimerInteractor & AnswerTimerInteractable
    
    // State Views
    var errorView: UIView?
    var loadingView: UIView?
    var emptyView: UIView?
    var alertViewController: UIViewController?
    
    // Properties
    private let interactor: Interactor
    let router: AnswerTimerRouter
    
    // UI
    private let refreshControl = UIActivityIndicatorView(style: .gray)
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let circleContainer = UIView()
    private let circleView = AnswerTimerCircle()
    private let informationLabel = UILabel()
    
    init(interactor: Interactor, router: AnswerTimerRouter) {
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
        
        interactor.dispatch(AnswerTimer.Action.load)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
    }
    
    func display() {
        guard let viewModel = viewModelState?.viewModel else { return }
        
        title = viewModel.title
        
        titleLabel.text = ~"answer_timer_title"
        circleView.text = viewModel.time
        informationLabel.text = ~"answer_timer_information"
    }
    
    @objc
    func reload() {
        interactor.dispatch(.load)
    }
    
    // MARK: - Required Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnswerTimerViewController {
    private func setupView() {
        view.backgroundColor = Theme.backgroundColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubviews(
            stackView.style(stackViewStyle)
        )
        
        circleContainer.addSubviews(
            circleView,
            informationLabel.style(informationLabelStyle)
        )
        
        stackView.addArrangedSubview(titleLabel.style(titleLabelStyle))
        stackView.addArrangedSubview(circleContainer)
        stackView.addArrangedSubview(refreshControl.style(refreshControlStyle))
    }
    
    private func setupConstraints() {
        let offset = min(48, UIScreen.main.bounds.height * 0.0267)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(offset)
            $0.leading.equalTo(view.snp.leading).offset(offset)
            $0.trailing.equalTo(view.snp.trailing).offset(-offset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-offset)
        }
        
        circleContainer.snp.makeConstraints {
            $0.left.equalTo(stackView.snp.left)
            $0.right.equalTo(stackView.snp.right)
        }
        
        circleView.snp.makeConstraints {
            $0.top.equalTo(circleContainer.snp.top)
            $0.centerX.equalTo(circleContainer.snp.centerX)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.bottom).offset(24)
            $0.left.equalTo(circleContainer.snp.left)
            $0.right.equalTo(circleContainer.snp.right)
            $0.bottom.equalTo(circleContainer.snp.bottom)
        }
    }
}

extension AnswerTimerViewController {
    private func titleLabelStyle(_ label: UILabel) {
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Theme.primaryLight
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
    }
    
    private func informationLabelStyle(_ label: UILabel) {
        label.font = Theme.Font.medium
        label.textColor = Theme.primary
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    private func refreshControlStyle(_ refreshControl: UIActivityIndicatorView) {
        refreshControl.tintColor = Theme.primary
        refreshControl.startAnimating()
    }
    
    private func stackViewStyle(_ stackView: UIStackView) {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
    }
}

