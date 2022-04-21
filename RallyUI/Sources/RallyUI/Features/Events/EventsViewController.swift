import UIKit
import SnapKit

class EventsViewController: UIViewController, FeatureViewController {
    
    // View Model
    var viewModel: Events.ViewModel?
    typealias ViewModel = Events.ViewModel
    typealias Interactor = EventsInteractor & EventsInteractable
    
    // State Views
    var errorView: UIView?
    var loadingView: UIView?
    var emptyView: UIView?
    var alertViewController: UIViewController?
    
    // Properties
    private let interactor: Interactor
    private let router: EventsRouter
    
    // UI
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let noInternetView = NoInternetView()
    
    init(interactor: Interactor, router: EventsRouter) {
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
        
        interactor.dispatch(Events.Action.load)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
    }
    
    func display() {
        guard let viewModel = viewModelState?.viewModel else { return }
        
        title = viewModel.title
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        noInternetView.snp.updateConstraints {
            $0.height.equalTo(viewModel.isConnected ? 0 : 70)
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

extension EventsViewController {
    private func setupView() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: ~"back", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ~"login_logout", style: .done, target: self, action: #selector(logout))
        
        view.addSubviews(
            noInternetView,
            tableView.style(tableViewStyle)
        )
    }
    
    private func setupConstraints() {
        noInternetView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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

extension EventsViewController {
    private func tableViewStyle(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        tableView.separatorColor = Theme.separatorColor
        tableView.registerReusableCell(EventsTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModelState?.viewModel else { return 0 }
        
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModelState?.viewModel else { return UITableViewCell() }
        
        let cell: EventsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(for: viewModel.items[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModelState?.viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.items[indexPath.row]
        router.route(to: item.route)

    }
}

extension EventsViewController {
    @objc
    private func logout() {
        interactor.dispatch(.logout)
    }
}
