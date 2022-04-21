import UIKit
import RxSwift
import RallyCore

protocol AnswerInteractable {
    func dispatch(_ action: Answer.Action)
}

class AnswerInteractor: FeatureInteractor, AnswerInteractable {
    private let presenter: AnswerPresenter
    private let questionAnswerRepository: QuestionAnswerRepository
    private let router: AnswerRouter
    private let questionAnswerRequestQueue: QuestionAnswerRequestQueue
    private let connectionWatcher: ConnectionWatcher
    private let locationHandler: LocationHandlerProtocol
    private let question: RallyCore.Question
    private let event: RallyCore.Event
    private let user: RallyCore.User
    
    private var disposeBag = DisposeBag()
    
    private var contentState: ContentState<Answer.Data> = .loading(data: nil) {
        didSet {
            guard contentState != oldValue else { return }
            presenter.present(contentState)
        }
    }
    
    init(presenter: AnswerPresenter,
         questionAnswerRepository: QuestionAnswerRepository,
         router: AnswerRouter,
         questionAnswerRequestQueue: QuestionAnswerRequestQueue,
         connectionWatcher: ConnectionWatcher,
         locationHandler: LocationHandlerProtocol,
         question: RallyCore.Question,
         event: RallyCore.Event,
         user: RallyCore.User) {
        self.presenter = presenter
        self.questionAnswerRepository = questionAnswerRepository
        self.router = router
        self.questionAnswerRequestQueue = questionAnswerRequestQueue
        self.connectionWatcher = connectionWatcher
        self.locationHandler = locationHandler
        self.question = question
        self.event = event
        self.user = user
    }
    
    func dispatch(_ action: Answer.Action) {
        switch action {
        case .load:
            load()
        case .submit(let value):
            submit(value)
        case .selectChoice(let choiceIndex):
            selectChoice(choiceIndex)
        }
    }
    
    func load() {
        disposeBag = DisposeBag()
        
        contentState = .loaded(
            data: Answer.Data(
                event: event,
                question: question,
                selectedChoice: contentState.data?.selectedChoice
            ),
            error: nil
        )
        selectInitialChoice(for: question)
    }
    
    func subscribe() {
        presenter.present(contentState)
    }
    
    func unsubscribe() {
        disposeBag = DisposeBag()
    }
}

extension AnswerInteractor {
    private func selectChoice(_ no: Int) {
        guard var data = contentState.data else { return }
        
        data.selectedChoice = no
        
        contentState = .loaded(data: data, error: nil)
    }
    
    private func selectInitialChoice(for question: RallyCore.Question) {
        guard contentState.data?.selectedChoice == nil else {
            return
        }
        
        if let value = question.state.value, let questionNo = Int(value) {
            selectChoice(questionNo)
        }
    }
}

extension AnswerInteractor {
    private func submit(_ value: String?) {
        guard let sessionId = user.sessionId else { return }
        let eventId = event.eventId
        
        var text: String?
        var number: String?
        var answerNo: Int?
        let questionNo = question.no
        
        switch question.type {
        case .choice:
            answerNo = contentState.data?.selectedChoice
        case .decimal, .number:
            number = value
        case .text:
            text = value
        }
        
        let questionAnswer = RallyCore.QuestionAnswer(
            sessionId: sessionId,
            eventId: eventId,
            questionNo: questionNo,
            answerNo: answerNo,
            text: text,
            number: number,
            submitTimestamp: Date(),
            sendTimestamp: nil
        )
        
        contentState = .loading(data: contentState.data)
        
        if connectionWatcher.getCurrentStatus() == .noConnection {
            setSavedWithoutConnection(questionAnswer)
        }
        
        questionAnswerRequestQueue.add(answer: questionAnswer)
        self.router.route(to: .back)
    }
    
    private func setSavedWithoutConnection(_ questionAnswer: QuestionAnswer) {
        guard var data = contentState.data else { return }
        data.savedNoConnection = true
        contentState = .loaded(data: data, error: nil)
    }
}

extension AnswerInteractor {
    func isInCorrectLocation() -> Bool {
        guard let location = locationHandler.getCurrentLocation() else {
            return false
        }
        
        return QuestionInAreaCalculator.isQuestionInArea(self.question, in: location)
    }
    
    func cannotAnswerMoreThanOnce() -> Bool {
        return question.state.isAnswered && question.isAnswerableOnce == true
    }
}
