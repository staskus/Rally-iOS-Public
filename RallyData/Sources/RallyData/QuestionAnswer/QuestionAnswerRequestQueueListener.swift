//
//  QuestionAnswerRequestQueueListener.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation
import RxSwift
import RallyCore

final class QuestionAnswerRequestQueueListener: RallyCore.QuestionAnswerRequestQueueListener {
    private let queue: RallyCore.QuestionAnswerRequestQueue
    private let repository: RallyCore.QuestionAnswerRepository
    private let connectionWatcher: RallyCore.ConnectionWatcher
    private var disposeBag = DisposeBag()
    private var retryAfterMinutes: TimeInterval = 5 * 60
    
    init(
        queue: RallyCore.QuestionAnswerRequestQueue,
        repository: RallyCore.QuestionAnswerRepository,
        connectionWatcher: RallyCore.ConnectionWatcher
    ) {
        self.queue = queue
        self.repository = repository
        self.connectionWatcher = connectionWatcher
    }
    
    func startListening() {
        makeRequests(queue.getAll())
        
        queue.onAdded()
            .subscribe(
                onNext: { [weak self] questionAnswers in
                    self?.makeRequests(questionAnswers)
            })
            .disposed(by: disposeBag)
        
        connectionWatcher.getStatusChanges()
            .subscribe(
                onNext: { [weak self] status in
                    guard let self = self else { return }
                    
                    switch status {
                    case .connected:
                        self.makeRequests(self.queue.getAll())
                    default:
                        break
                    }
            })
            .disposed(by: disposeBag)
    }
    
    func stopListening() {
        disposeBag = DisposeBag()
    }
    
    private func makeRequests(_ questionAnswers: [QuestionAnswer]) {
        let makeAnswers = questionAnswers.map { answer in
            repository
                .answer(answer)
                .map { ($0, answer) }
        }
        
        Observable
            .combineLatest(makeAnswers)
            .subscribe(
                onNext: { [weak self] results in
                    guard let self = self else { return }
                                        
                    results
                        .filter { $0.0.isAccepted }
                        .map { $0.1.questionNo }
                        .forEach(self.queue.remove)
                },
                onError: { [weak self] _ in
                    guard let self = self else { return }

                    DispatchQueue.main.asyncAfter(deadline: .now() + self.retryAfterMinutes) { [weak self] in
                        guard let self = self else { return }
                        self.makeRequests(self.queue.getAll())
                    }
            })
            .disposed(by: disposeBag)
    }
}
