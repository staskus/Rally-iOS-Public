import UIKit
import RxSwift
import RallyCore

protocol AnswerTimerInteractable {
    func dispatch(_ action: AnswerTimer.Action)
}

class AnswerTimerInteractor: FeatureInteractor, AnswerTimerInteractable {
    private let presenter: AnswerTimerPresenter
    private let router: AnswerTimerRouter
    private var disposeBag = DisposeBag()
    private let question: RallyCore.Question
    private let event: RallyCore.Event
    private let user: RallyCore.User
    private let viewTimeRepository: RallyCore.ViewTimeRepository
    private var countdownTimer: Timer?
    private var isSend: Bool = false

    private var contentState: ContentState<AnswerTimer.Data> = .loading(data: nil) {
        didSet {
            guard contentState != oldValue else { return }
            presenter.present(contentState)
        }
    }

    init(presenter: AnswerTimerPresenter,
         router: AnswerTimerRouter,
         question: RallyCore.Question,
         event: RallyCore.Event,
         user: RallyCore.User,
         viewTimeRepository: RallyCore.ViewTimeRepository) {
        self.presenter = presenter
        self.router = router
        self.question = question
        self.event = event
        self.user = user
        self.viewTimeRepository = viewTimeRepository
    }

    func dispatch(_ action: AnswerTimer.Action) {
        switch action {
        case .load:
            load()
        }
    }

    func load() {
        disposeBag = DisposeBag()
        
        contentState = .loaded(data: AnswerTimer.Data(question: question,
                                                      event: event,
                                                      time: "10"),
                               error: nil)
        startTimer()
        sendViewTime(Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 10))
    }

    func subscribe() {
        presenter.present(contentState)
    }

    func unsubscribe() {
        disposeBag = DisposeBag()
    }
}

extension AnswerTimerInteractor {
    private func handleTimerEnded() {
        if isSend {
            router.route(to: .question(question))
        } else {
            router.route(to: .error)
        }
    }
}

extension AnswerTimerInteractor {
    private func sendViewTime(_ time: Date) {
        guard let sessionId = user.sessionId else { return }
        
        let viewTime = ViewTime(sessionId: sessionId,
                                eventId: event.eventId,
                                questionNo: question.no,
                                firstSeenTimestamp: time)
        
        viewTimeRepository.sendViewTime(viewTime)
            .subscribe(onNext: { [weak self] in
                guard $0.isAccepted else {
                    self?.sendViewTime(time)
                    return
                }
                
                self?.isSend = true
                
                }, onError: { [weak self] _ in
                    self?.sendViewTime(time)
            })
            .disposed(by: disposeBag)
    }
}

extension AnswerTimerInteractor {
    private func startTimer() {
        let startTime: TimeInterval = 10
        var currentTime = startTime
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] _ in
            currentTime-=1
            
            self.contentState = .loaded(
                data: AnswerTimer.Data(
                    question: self.question,
                    event: self.event,
                    time: "\(Int(currentTime))"
                ),
            error: nil)
            
            if currentTime == 0 {
                self.countdownTimer?.invalidate()
                self.handleTimerEnded()
            }
        })
    }
}
