//
//  QuestionAnswerRequestQueue.swift
//  
//
//  Created by Povilas Staskus on 11/14/19.
//

import Foundation
import RxSwift
import RallyCore

final class QuestionAnswerRequestQueue: RallyCore.QuestionAnswerRequestQueue {
    private let defaults: UserDefaults = .standard
    private let key = "question.answer.queue.key"
    private let addedPublishSubject = PublishSubject<[QuestionAnswer]>()
    private let removedPublishSubject = PublishSubject<[QuestionAnswer]>()
    
    func add(answer: QuestionAnswer) {
        if exists(questionNo: answer.questionNo) {
            remove(questionNo: answer.questionNo)
        }
        
        var queue: [QuestionAnswer] = getAll()
        queue.append(answer)
        
        defaults.set(try? PropertyListEncoder().encode(queue), forKey: key)
        defaults.synchronize()
        addedPublishSubject.onNext(getAll())
    }
    
    func remove(questionNo: Int) {
        var queue: [QuestionAnswer] = getAll()
        
        guard (queue.map { $0.questionNo }).contains(questionNo) else {
            return
        }
        
        queue.removeAll(where: { $0.questionNo == questionNo } )
        
        defaults.set(try? PropertyListEncoder().encode(queue), forKey: key)
        defaults.synchronize()
        removedPublishSubject.onNext(getAll())
    }
    
    func getAll() -> [QuestionAnswer] {
        guard let data = defaults.object(forKey: key) as? Data else {
            return []
        }
        
        return (try? PropertyListDecoder().decode([QuestionAnswer].self, from: data)) ?? []
    }
    
    func onAdded() -> Observable<[QuestionAnswer]> {
        return addedPublishSubject.asObserver()
            .do(onNext: { result in
                print("ON ASNWER ADDED QUEUE: \(result.count)")
            })
    }
    
    func onRemoved() -> Observable<[QuestionAnswer]> {
        return removedPublishSubject.asObserver()
            .do(onNext: { result in
                print("ON ANSWER REMOVED QUEUE: \(result.count)")
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
