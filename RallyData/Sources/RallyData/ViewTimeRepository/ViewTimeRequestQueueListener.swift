//
//  ViewTimeRequestQueueListener.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import RxSwift
import RallyCore

final class ViewTimeRequestQueueListener: RallyCore.ViewTimeRequestQueueListener {
    private let queue: RallyCore.ViewTimeRequestQueue
    private let repository: RallyCore.ViewTimeRepository
    private let connectionWatcher: RallyCore.ConnectionWatcher
    private var disposeBag = DisposeBag()
    private var retryAfterMinutes: TimeInterval = 5 * 60
    
    init(
        queue: RallyCore.ViewTimeRequestQueue,
        repository: RallyCore.ViewTimeRepository,
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
                onNext: { [weak self] viewTimes in
                    self?.makeRequests(viewTimes)
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
    
    private func makeRequests(_ viewTimes: [ViewTime]) {
        let makeViewTimes = viewTimes.map { viewTime in
            repository
                .sendViewTime(viewTime)
                .map { ($0, viewTime) }
        }
        
        Observable
            .combineLatest(makeViewTimes)
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
