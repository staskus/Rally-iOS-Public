//
//  EventRepository.swift
//  
//
//  Created by Povilas Staskus on 10/26/19.
//

import Foundation
import RxSwift

public protocol EventRepository {
    func loadEvents() -> Observable<[Event]>
    func getEvents() -> [Event]
    func getTimeUntil(event: RallyCore.Event) -> TimeInterval
    func getCurrentEvent() -> Event?
    func getNextEvent() -> Event?
}
