import UIKit
import RxSwift
import RallyCore
import CoreLocation

protocol QuestionsInteractable {
    func dispatch(_ action: Questions.Action)
}

class QuestionsInteractor: FeatureInteractor, QuestionsInteractable {
    private let presenter: QuestionsPresenter
    private var disposeBag = DisposeBag()
    
    private let userRepository: UserRepository
    private let eventRepository: EventRepository
    private let questionsRepository: QuestionsRepository
    private let permissionHandler: PermissionHandler
    private let locationHandler: LocationHandlerProtocol
    private let questionAnswerQueue: QuestionAnswerRequestQueue
    private let connectionWatcher: ConnectionWatcher
    private let router: QuestionsRouter
    private let event: RallyCore.Event
    private let user: RallyCore.User
    
    private var eventStartTimer: Timer?

    private var contentState: ContentState<Questions.Data> = .loading(data: nil) {
        didSet {
            guard contentState != oldValue else { return }
            presenter.present(contentState)
        }
    }

    init(presenter: QuestionsPresenter,
         router: QuestionsRouter,
         userRepository: UserRepository,
         eventRepository: EventRepository,
         questionsRepository: QuestionsRepository,
         permissionHandler: PermissionHandler,
         locationHandler: LocationHandlerProtocol,
         questionAnswerQueue: QuestionAnswerRequestQueue,
         connectionWatcher: ConnectionWatcher,
         user: RallyCore.User,
         event: RallyCore.Event) {
        self.presenter = presenter
        self.router = router
        self.userRepository = userRepository
        self.eventRepository = eventRepository
        self.questionsRepository = questionsRepository
        self.permissionHandler = permissionHandler
        self.locationHandler = locationHandler
        self.questionAnswerQueue = questionAnswerQueue
        self.connectionWatcher = connectionWatcher
        self.user = user
        self.event = event
    }

    func dispatch(_ action: Questions.Action) {
        switch action {
        case .load:
            load()
        case .logout:
            logout()
        case .askForLocation:
            if permissionHandler.canAskLocationPermission() {
                permissionHandler.askForLocationPermission()
            } else {
                router.route(to: .settings)
            }
        }
    }

    func load() {
        disposeBag = DisposeBag()
        
        loadEvents()
        updateLoadingState()
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
    
    private func loadEvents() {
        self.contentState = .loading(
            data: Questions.Data(
                user: user,
                questions: contentState.data?.questions ?? [],
                activationTime: contentState.data?.activationTime,
                deactivationTime: contentState.data?.deactivationTime,
                event: event,
                timeUntilEvent: eventRepository.getTimeUntil(event: event),
                locationPermission: getLocationPermissionData(),
                location: contentState.data?.location,
                connnectionStatus: connectionWatcher.getCurrentStatus(),
                loadingAnswers: questionAnswerQueue.getAll()
            )
        )
        
        startObservers()
        loadQuestions(for: event)
        startEventStartTimerIfNeeded(event)
    }
    
    private func loadQuestions(for event: RallyCore.Event) {
        questionsRepository.getQuestions(byEventId: event.eventId).subscribe(
            onNext: { [unowned self] questions in
                guard var data = self.contentState.data else {
                    return
                }
                
                data.questions = questions.questions
                data.activationTime = questions.activationTime
                data.deactivationTime = questions.deactivationTime
                self.contentState = .loaded(data: data, error: nil)
            },
            onError: { error in
                if let data = self.contentState.data, !data.questions.isEmpty {
                    self.contentState = .loaded(data: data, error: .loading(reason: ~"questions_error_refresh_questions_title"))
                } else {
                    self.contentState = .error(error: .loading(reason: ~"questions_no_questions_title"))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func startObservers() {
        observeLocationUpdates()
        observeConnectionUpdates()
        observeAnswerQueueUpdates()
    }

    func subscribe() {
        presenter.present(contentState)
        permissionHandler.delegate = self
    }

    func unsubscribe() {
        disposeBag = DisposeBag()
        permissionHandler.delegate = nil
    }
}

extension QuestionsInteractor {
    private func startEventStartTimerIfNeeded(_ event: RallyCore.Event) {
        let timeUntilEvent = eventRepository.getTimeUntil(event: event)
        guard timeUntilEvent > 0 else { return }
        
        eventStartTimer = Timer.scheduledTimer(withTimeInterval: timeUntilEvent, repeats: false, block: { [weak self] _ in
            self?.load()
        })
        
        if let timer = eventStartTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
}

extension QuestionsInteractor: PermissionHandlerDelegate {
    func locationPermissionStatusChanged() {
        guard var data = self.contentState.data else {
            return
        }
        
        data.locationPermission = getLocationPermissionData()
        self.contentState = .loaded(data: data, error: nil)
    }
    
    private func getLocationPermissionData() -> Questions.Data.LocationPermission {
        return Questions.Data.LocationPermission(
            noLocationPermission: permissionHandler.isLocationDenied() || permissionHandler.canAskLocationPermission()) { [weak self] in
                self?.dispatch($0)
        }
    }
}

extension QuestionsInteractor {
    private func observeLocationUpdates() {
        locationHandler.getLocation()
            .do(onNext: { location in
                print("Location updated: \(location.coordinate)")
            })
            .subscribe(onNext: changeLocation)
            .disposed(by: disposeBag)
    }
    
    private func changeLocation(_ location: CLLocation) {
        guard var data = contentState.data else {
            return
        }
        
        data.location = location
        self.contentState = .loaded(data: data, error: nil)
    }
}

extension QuestionsInteractor {
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

extension QuestionsInteractor {
    private func observeAnswerQueueUpdates() {
        Observable.combineLatest(
            questionAnswerQueue.onAdded(),
            questionAnswerQueue.onRemoved()
        )
        .subscribe(
            onNext: { [weak self] _ in
                guard let self = self else { return }

                guard var data = self.contentState.data else {
                    return
                }
                
                let currentAnswers = self.questionAnswerQueue.getAll()
                guard data.loadingAnswers != currentAnswers else {
                    return
                }
                
                data.loadingAnswers = currentAnswers
                self.contentState = .loaded(data: data, error: nil)
                self.loadEvents()
        })
        .disposed(by: disposeBag)
    }
}

extension QuestionsInteractor {
    private func updateLoadingState() {
        guard var data = contentState.data else {
            return
        }
        
        data.loadingAnswers = questionAnswerQueue.getAll()
        contentState = .loaded(data: data, error: nil)
    }
}
