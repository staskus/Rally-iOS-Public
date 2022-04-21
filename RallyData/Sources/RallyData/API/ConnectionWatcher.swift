//
//  ConnectionWatcher.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation
import RallyCore
import RxSwift
import Reachability

final class ConnectionWatcher: RallyCore.ConnectionWatcher {
    private let reachability: Reachability?
    private let publishSubject = PublishSubject<ConnectionWatcherStatus>()

    init() {
        self.reachability = try? Reachability()
    }
    
    func startListening() {
        guard let reachability = reachability else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(note:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    func stopListening() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func reachabilityChanged(note: Notification) {
        publishSubject.onNext(getCurrentStatus())
        print("Connection Watcher Changed: \(getCurrentStatus())")
    }
    
    func getCurrentStatus() -> ConnectionWatcherStatus {
        guard let reachability = reachability else { return .undefined }
        
        switch reachability.connection {
        case .wifi, .cellular:
            return .connected
        case .unavailable, .none:
            return .noConnection
        }
    }
    
    deinit {
        stopListening()
    }
    
    func getStatusChanges() -> Observable<ConnectionWatcherStatus> {
        return publishSubject.asObservable()
    }
}
