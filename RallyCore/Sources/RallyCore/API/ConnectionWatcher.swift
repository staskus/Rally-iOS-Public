//
//  ConnectionWatcher.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation
import RxSwift

public enum ConnectionWatcherStatus {
    case noConnection
    case connected
    case undefined
}

public protocol ConnectionWatcher {
    func startListening()
    func stopListening()
    func getStatusChanges() -> Observable<ConnectionWatcherStatus>
    func getCurrentStatus() -> ConnectionWatcherStatus
}
