//
//  ViewTimeRequestQueue.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import RxSwift
import RallyCore

final class ViewTimeRequestQueue: RallyCore.ViewTimeRequestQueue {
    private let defaults: UserDefaults = .standard
    private let key = "view.time.queue.key"
    private let addedPublishSubject = PublishSubject<[ViewTime]>()
    private let removedPublishSubject = PublishSubject<[ViewTime]>()
    
    func add(viewTime: ViewTime) {
        if exists(questionNo: viewTime.questionNo) {
            remove(questionNo: viewTime.questionNo)
        }
        
        var queue: [ViewTime] = getAll()
        queue.append(viewTime)
        
        defaults.set(try? PropertyListEncoder().encode(queue), forKey: key)
        defaults.synchronize()
        addedPublishSubject.onNext(getAll())
    }
    
    func remove(questionNo: Int) {
        var queue: [ViewTime] = getAll()
        
        guard (queue.map { $0.questionNo }).contains(questionNo) else {
            return
        }
        
        queue.removeAll(where: { $0.questionNo == questionNo } )
        
        defaults.set(try? PropertyListEncoder().encode(queue), forKey: key)
        defaults.synchronize()
        removedPublishSubject.onNext(getAll())
    }
    
    func getAll() -> [ViewTime] {
        guard let data = defaults.object(forKey: key) as? Data else {
            return []
        }
        
        return (try? PropertyListDecoder().decode([ViewTime].self, from: data)) ?? []
    }
    
    func onAdded() -> Observable<[ViewTime]> {
        return addedPublishSubject.asObserver()
            .do(onNext: { result in
                print("ON VIEW TIME ADDED QUEUE: \(result.count)")
            })
    }
    
    func onRemoved() -> Observable<[ViewTime]> {
        return removedPublishSubject.asObserver()
            .do(onNext: { result in
                print("ON VIEW TIME REMOVED QUEUE: \(result.count)")
            })
    }
    
    func exists(questionNo: Int) -> Bool {
        return getAll().first(where: { $0.questionNo == questionNo }) != nil
    }
        
    func clear() {
        defaults.set(nil, forKey: key)
        defaults.synchronize()
    }
}
