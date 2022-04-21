import UIKit
import SnapKit

class QuestionsViewController: UIViewController, FeatureViewController {
    
    // View Model
    var viewModel: Questions.ViewModel?
    typealias ViewModel = Questions.ViewModel
    typealias Interactor = QuestionsInteractor & QuestionsInteractable
    
    // State Views
    var errorView: UIView?
    var loadingView: UIView?
    var emptyView: UIView?
    var alertViewController: UIViewController?
    
    // Properties
    private let interactor: Interactor
    private let router: QuestionsRouter
    
    // UI
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let noInternetView = NoInternetView()
    private let teamView = TeamView()
    
    init(interactor: Interactor, router: QuestionsRouter) {
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
        
        interactor.dispatch(Questions.Action.load)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
    }
    
    func display() {
        guard let viewModel = viewModelState?.viewModel else { return }
        
        if let emptyViewModel = viewModel.empty {
            (emptyView as? EmptyView)?.configure(emptyViewModel)
        }
        
        title = viewModel.title
        teamView.title.attributedText = viewModel.subtitle
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        noInternetView.snp.updateConstraints {
            $0.height.equalTo(viewModel.isConnected ? 0 : 70)
        }
        
        teamView.snp.removeConstraints()
        teamView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(noInternetView.snp.top)
            
            if viewModel.subtitle.length == 0 {
                $0.height.equalTo(0)
            } else {
                $0.height.greaterThanOrEqualTo(24)
            }
        }
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

extension QuestionsViewController {
    private func setupView() {
        view.backgroundColor = Theme.backgroundColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = UIBarButtonItem(title: ~"back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ~"login_logout", style: .done, target: self, action: #selector(logout))
        
        view.addSubviews(
            teamView,
            noInternetView,
            tableView.style(tableViewStyle)
        )
    }
    
    private func setupConstraints() {
        teamView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(noInternetView.snp.top)
            $0.height.equalTo(24)
        }
        
        noInternetView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(tableView.snp.top)
            $0.height.equalTo(0)
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
}

extension QuestionsViewController {
    private func tableViewStyle(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        tableView.separatorColor = Theme.separatorColor
        tableView.registerReusableCell(QuestionTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
}

extension QuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModelState?.viewModel else { return 0 }
        
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModelState?.viewModel else { return UITableViewCell() }
        
        let cell: QuestionTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(for: viewModel.items[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension QuestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModelState?.viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.items[indexPath.row]
        
        if let message = viewModel.inactiveBefore ?? viewModel.inactiveAfter {
            showInactiveAlert(message)
            return
        }
        
        switch item.state {
        case .closed:
            showQuestionClosedAlert()
        case .loading:
            showLastAnswerLoadingAlert(item.route)
        default:
            router.route(to: item.route)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

extension QuestionsViewController {
    private func showQuestionClosedAlert() {
        let alert = UIAlertController(
            title: ~"questions_inactive_alert_title",
            message: ~"questions_inactive_alert_description",
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

extension QuestionsViewController {
    @objc
    private func logout() {
        interactor.dispatch(.logout)
    }
}

extension QuestionsViewController {
    private func showLastAnswerLoadingAlert(_ route: Questions.Route) {
        let alert = UIAlertController(
            title: ~"questions_no_internet_done_alert_title",
            message: ~"questions_last_answer_loading_details",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { [unowned self] _ in
                self.router.route(to: route)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension QuestionsViewController {
    private func showInactiveAlert(_ message: String) {
        let alert = UIAlertController(
            title: ~"questions_inactive_alert_title",
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        )
        
        present(alert, animated: true, completion: nil)
    }
}
