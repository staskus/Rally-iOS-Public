import UIKit
import RxSwift
import RallyCore

protocol EventsInteractable {
    func dispatch(_ action: Events.Action)
}

class EventsInteractor: FeatureInteractor, EventsInteractable {
    private let presenter: EventsPresenter
    private var disposeBag = DisposeBag()
    
    private let userRepository: UserRepository
    private let eventRepository: EventRepository
    private let connectionWatcher: ConnectionWatcher
    private let router: EventsRouter

    private var contentState: ContentState<Events.Data> = .loading(data: nil) {
        didSet {
            guard contentState != oldValue else { return }
            presenter.present(contentState)
        }
    }

    init(presenter: EventsPresenter,
         userRepository: UserRepository,
         eventRepository: EventRepository,
         connectionWatcher: ConnectionWatcher,
         router: EventsRouter) {
        self.presenter = presenter
        self.userRepository = userRepository
        self.eventRepository = eventRepository
        self.connectionWatcher = connectionWatcher
        self.router = router
    }

    func dispatch(_ action: Events.Action) {
        switch action {
        case .load:
            load()
        case .logout:
            logout()
        }
    }

    func load() {
        disposeBag = DisposeBag()

        contentState = .loading(data: contentState.data)
        loadEvents()
    }

    func subscribe() {
        presenter.present(contentState)
    }

    func unsubscribe() {
        disposeBag = DisposeBag()
    }
    
    private func loadEvents() {
        guard let user = userRepository.getUser() else {
            router.route(to: .logout)
            return
        }
        
        if let data = contentState.data, data.events.isEmpty {
            contentState = .loading(data: contentState.data)
        }
        
        eventRepository.loadEvents()
            .map { [weak self] _ -> [RallyCore.Event] in
                guard let self = self else { return [] }
                
                return self.eventRepository
                    .getEvents()
                    .filter(self.filterCurrentEvent)
            }
            .subscribe(
                onNext: { [weak self] events in
                    guard let self = self else { return }
                    
                    guard !events.isEmpty else {
                        self.contentState = .error(error: .loading(reason: ~"questions_no_events_title"))
                        return
                    }
                    
                    self.contentState = .loaded(
                        data:
                        Events.Data(user: user,
                                    events: events,
                                    connnectionStatus: self.connectionWatcher.getCurrentStatus()),
                        error: nil
                    )
                    
                    self.observeConnectionUpdates()
                }, onError: { [weak self] _ in
                    self?.observeConnectionUpdates()
                    
                    if self?.contentState.data?.events == nil {
                        self?.contentState = .error(error: .loading(reason: ~"questions_no_events_title"))
                    }
                    
                    if let events = self?.contentState.data?.events, events.isEmpty {
                        self?.contentState = .error(error: .loading(reason: ~"questions_no_events_title"))
                    }
            })
            .disposed(by: disposeBag)
    }
    
    private func logout() {
        contentState = .loading(data: contentState.data)
        
        userRepository.logout()
            .subscribe(
                onNext: { [weak self] _ in
                    self?.router.route(to: .logout)
                },
                onError: { [weak self] _ in
                    self?.router.route(to: .logout)
            })
            .disposed(by: disposeBag)
    }
}

extension EventsInteractor {
    private func observeConnectionUpdates() {
        connectionWatcher.getStatusChanges()
            .subscribe(
                onNext: { [weak self] status in
                    guard let self = self else { return }

                    guard var data = self.contentState.data else {
                        return
                    }
                    
                    guard data.connnectionStatus != status else {
                        return
                    }
                    
                    if status == .noConnection {
                        data.connnectionStatus = status
                        self.contentState = .loaded(data: data, error: nil)
                    } else {
                        self.loadEvents()
                    }
                    
            })
            .disposed(by: disposeBag)
    }
}

extension EventsInteractor {
    private func filterCurrentEvent(_ event: RallyCore.Event) -> Bool {
        let currentDate = Date().timeIntervalSince1970
        let eventFrom = event.from.timeIntervalSince1970
        let eventUntil = event.until.timeIntervalSince1970
        
        return eventFrom <= currentDate && currentDate < eventUntil
    }
}
